import 'package:flags/domain/models/app/game_preferences_data.dart';
import 'package:flags/domain/preferences/builders/build_game_preferences.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WinnerStreakView extends StatelessWidget {
  const WinnerStreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildGamePreferences(
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
    );
  }
}
