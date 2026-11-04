import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/features/continents_picker/presentation/views/strick_view.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FastModePlayTimerView extends StatelessWidget {
  const FastModePlayTimerView({
    super.key,
    required this.onTapPlayFastMode,
    required this.showcaseKey,
  });

  final GlobalKey showcaseKey;

  final VoidCallback onTapPlayFastMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 100.h,
          height: 200.h,
          left: 0,
          right: 0,
          child: FShowcase(
            showcaseKey: showcaseKey,
            targetPadding: Pad(horizontal: -12.w, top: -24.h),
            tooltip: (bounds) => Positioned(
              top: bounds.top - 68.h,
              left: 0,
              right: 0,
              child: Center(
                child: FText(
                  'You can try\na more extreme mode',
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(height: 1),
                ),
              ),
            ),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  ScaledGestureDetector(
                    onTap: onTapPlayFastMode,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        Center(
                          child: Transform.translate(
                            offset: Offset(-84.w, 0),
                            child: SizedBox.square(
                              dimension: 128.r,
                              child: Center(
                                child: SpriteUIWidget(
                                  image: Assets.images.timer.image,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 142.w,
                          right: 0,
                          bottom: 32.h,
                          child: Center(
                            child: FText(
                              "Play",
                              textStyle: TextStyle(
                                fontSize: 64.sp,
                                color: ThemePalette.yellow,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: FText(
                              "Fast mode",
                              textStyle: TextStyle(fontSize: 48.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 64.w,
                    right: 0,
                    bottom: 120.h,
                    child: const Center(child: WinnerStreakView()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
