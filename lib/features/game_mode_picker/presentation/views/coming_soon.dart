import 'dart:math' as math;

import 'package:flags/uikit/components/buttons/colors/green_button.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Заглушка будущего режима: тёмная карточка того же размера, что и режимы,
/// с надписью по центру в том же стиле, что «Puzzles» и «Flag games».
class GameModeComingSoon extends StatelessWidget {
  const GameModeComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ThemeIndents.s24),
      child: AspectRatio(
        aspectRatio: 1.6 / 1,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 2.r,
                ),
              ),
            ),
            // надпись — в центре прямоугольника, стиль как у «Puzzles»/«Flag games»
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: FText(
                    'Coming soon...',
                    textAlign: TextAlign.center,
                    strokeWidth: 18.r,
                    textStyle: TextStyle(
                      color: const Color(0xFFB0B0B0),
                      fontSize: 56.sp,
                      height: 0.8, // межстрочный интервал, как у «Flag games»
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Пасхалка: короткий говорящий ответ на нажатия, без наград ────────────────
// Реплики по порядку; после последней она и повторяется.
const _kModeTalkLines = [
  'A new game mode is on its way!',
  'Yes, it is still on its way.',
  'Tapping harder won\'t speed it up.',
  'You again?',
  'Go solve some puzzles instead.',
  'I have nothing more to say.',
];
const _kModeTalkButtons = ['OK', 'OK', 'Sure', 'Fine', 'Go', 'Bye'];

// счётчик живёт, пока открыто приложение
int _modeTalkTaps = 0;

void showComingSoonModeTalk(BuildContext context) {
  final i = math.min(_modeTalkTaps, _kModeTalkLines.length - 1);
  _modeTalkTaps++;
  // чем дальше, тем краснее окно
  final anger = i / (_kModeTalkLines.length - 1);
  showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    useSafeArea: false,
    builder: (ctx) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFF1E1E1E),
              const Color(0xFF6E0E0E),
              anger,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FText(
                _kModeTalkLines[i],
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 22),
              FGreenButton(
                onPressed: () => Navigator.of(ctx).pop(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: FText(
                  _kModeTalkButtons[i],
                  textStyle: const TextStyle(fontSize: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
