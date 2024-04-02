import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/screens/continents_picker/views/strick_view.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

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
          bottom: 100,
          height: 200,
          left: 0,
          right: 0,
          child: FShowcase(
            showcaseKey: showcaseKey,
            targetPadding: const Pad(horizontal: -12, top: -24),
            tooltip: (bounds) => Positioned(
              top: bounds.top - 68,
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
                            offset: const Offset(-84, 0),
                            child: SizedBox.square(
                              dimension: 128,
                              child: Center(
                                child: SpriteUIWidget(
                                  image: Assets.images.timer.image,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 142,
                          right: 0,
                          bottom: 32,
                          child: Center(
                            child: FText(
                              "Play",
                              textStyle: const TextStyle(
                                fontSize: 64,
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
                              textStyle: const TextStyle(
                                fontSize: 48,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    left: 64,
                    right: 0,
                    bottom: 120,
                    child: Center(
                      child: WinnerStreakView(),
                    ),
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
