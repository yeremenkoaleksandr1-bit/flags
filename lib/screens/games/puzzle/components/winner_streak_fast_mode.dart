import 'package:armar/rx/rx.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class WinnerStreakFastModeView extends StatelessWidget {
  const WinnerStreakFastModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final winStreak = IAppPresenter.I.gameState.data.winStreak;

    return Padding(
      padding: const Pad(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 52,
            child: Center(
              child: Transform.rotate(
                angle: radians(-15),
                child: OutlineWidget(
                  child: SpriteUIWidget(image: Assets.images.winnerCup.image),
                ),
              ),
            ),
          ),
          Gap.h12,
          FastValueBuilder(
            listen: winStreak.currentStreakRx,
            builder: (int value) {
              return FText(
                value.toString(),
                textStyle: const TextStyle(
                  fontSize: 64,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
