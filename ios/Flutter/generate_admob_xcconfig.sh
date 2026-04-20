#!/bin/sh

set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$PROJECT_DIR/.env"
OUTPUT_FILE="$SCRIPT_DIR/AdMob.xcconfig"
DEFAULT_IOS_APP_ID="ca-app-pub-3940256099942544~1458002511"

IOS_APP_ID="$DEFAULT_IOS_APP_ID"

if [ -f "$ENV_FILE" ]; then
  ENV_VALUE="$(grep '^ADMOB_IOS_APP_ID=' "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  if [ -n "$ENV_VALUE" ]; then
    IOS_APP_ID="$ENV_VALUE"
  fi
fi

printf "ADMOB_IOS_APP_ID=%s\n" "$IOS_APP_ID" > "$OUTPUT_FILE"
