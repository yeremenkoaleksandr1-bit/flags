import 'package:flags/domain/domain.dart';
import 'package:flags/features/continents_picker/presentation/components/completed_levels_count_stream_view.dart';
import 'package:flags/features/continents_picker/presentation/components/white_panel.dart';
import 'package:flags/uikit/text/text.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.continent,
    required this.gameMode,
    required this.levelsCount,
  });

  final ContinentType continent;
  final GameProcessType gameMode;
  final int levelsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CompletedLevelsCountStreamBuilder(
            continent: continent,
            gameMode: gameMode,
            builder: (completed) {
              final progress = levelsCount == 0
                  ? 0.0
                  : completed / levelsCount;

              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: Container(
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF274D7D),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                            width: 1.5.r,
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(4.0.r),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFF6FD421),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  FText(
                    '$completed / $levelsCount',
                    textColor: const Color(0xFF1A2330),
                    strokeColor: ThemePalette.white,
                    strokeWidth: 2,
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
