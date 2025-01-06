import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/models/app/game_preferences_data.dart';
import 'package:flags/domain/preferences/builders/build_game_preferences.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WinnerStreakView extends StatelessWidget {
  const WinnerStreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 38,
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
          BuildGamePreferences(
            buildWhen: (
              previous,
              current,
            ) =>
                previous.winStreak.longestStreak !=
                current.winStreak.longestStreak,
            builder: (
              BuildContext context,
              GamePreferencesState state,
            ) {
              return FText(
                '${state.winStreak.longestStreak}',
                textStyle: const TextStyle(
                  fontSize: 24,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
