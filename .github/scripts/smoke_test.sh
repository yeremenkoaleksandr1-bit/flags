#!/usr/bin/env bash
# Installs the APK on the running emulator, launches it and checks that the
# app gets past the native (black) launch splash and does not crash.
# Usage: smoke_test.sh <apk> <out-dir>
set -u
APK="$1"
OUT="$2"
PKG=com.forceman.flagsup
mkdir -p "$OUT"

adb shell getprop ro.build.version.release | tee "$OUT/android_version.txt"
adb install -r "$APK" || { echo "INSTALL FAILED"; exit 1; }
adb logcat -c
adb shell am start -W -n "$PKG/.MainActivity"

# Give the app time to start (emulators on CI are slow), sampling the screen.
for t in 15 30 45 60; do
  sleep 15
  adb exec-out screencap -p > "$OUT/screen_${t}s.png"
done

adb logcat -d > "$OUT/logcat.txt"
PID=$(adb shell pidof "$PKG" | tr -d '\r')

echo "===== relevant logcat ====="
grep -E "flutter|AndroidRuntime|FATAL|F DEBUG|Startup step|GameShaders|SkSL|Impeller|Skia|libc  " "$OUT/logcat.txt" | tail -150

pip install --quiet pillow >/dev/null 2>&1
python3 - "$OUT/screen_60s.png" <<'PY'
import sys
from PIL import Image
im = Image.open(sys.argv[1]).convert('RGB').resize((90, 160))
px = list(im.getdata())
dark = sum(1 for r, g, b in px if r + g + b < 60) / len(px)
avg = tuple(sum(c[i] for c in px) // len(px) for i in range(3))
print(f"SCREEN dark_ratio={dark:.2f} avg_rgb={avg}")
open(sys.argv[1] + '.dark', 'w').write(f"{dark:.2f}")
PY
DARK=$(cat "$OUT/screen_60s.png.dark")

echo "PID=${PID:-<none>}"
if [ -z "$PID" ]; then
  echo "RESULT: FAIL - app process is not running (crashed)"
  exit 1
fi
if python3 -c "import sys; sys.exit(0 if float('$DARK') > 0.85 else 1)"; then
  echo "RESULT: FAIL - still on black launch splash after 60s"
  exit 1
fi
echo "RESULT: PASS - app rendered Flutter UI"
