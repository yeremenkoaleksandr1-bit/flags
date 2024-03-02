import 'package:flags/screens/continents_picker/views/strick_view.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

import '../../../uikit/assets/assets.dart';

class FastModePlayTimerView extends StatelessWidget {
  const FastModePlayTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
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
                  bottom: 16,
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
                  bottom: -24,
                  child: Center(
                    child: FText(
                      "Fast mode",
                      textStyle: const TextStyle(
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 100,
                  child: Center(
                    child: WinnerStreakView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
