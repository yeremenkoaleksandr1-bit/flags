import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlappyModeView extends StatelessWidget {
  const FlappyModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ThemeIndents.s24),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1.6 / 1,
              child: FCard(
                padding: EdgeInsets.zero,
                color: const Color(0xFF147F55),
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.passthrough,
                  children: [
                    // превью режима; углы скругляем под рамку карточки
                    Positioned.fill(
                      child: Container(
                        // тонкая синяя рамка поверх картинки
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFF2F3FB0),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(
                            'assets/images/ui/flag_games_mode.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // как у «Puzzles»: размеры масштабируются под экран (.sp/.r/.h),
                    // надпись прижата к левому верхнему углу карточки
                    Positioned(
                      top: -52.h,
                      left: 0,
                      right: 48.w,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FText(
                          "Flag games",
                          textAlign: TextAlign.left,
                          strokeWidth: 18.r,
                          textStyle: TextStyle(
                            color: const Color(
                              0xFF87CEEB,
                            ).withValues(alpha: 0.6),
                            fontSize: 64.sp,
                            height: 0.8, // межстрочный интервал (1.0 — обычный)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
