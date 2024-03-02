import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../levels_picker/features/color_by_difficult.dart';

class CurrentLevelIndex extends StatelessWidget {
  const CurrentLevelIndex({super.key, required this.level});

  final GameLevel level;

  @override
  Widget build(BuildContext context) {
    final gameLevels = ILevelsPickerPresenter.i.state.levels;

    final levels = gameLevels.levels;

    final levelIndex = levels.indexWhere((e) => e == level) + 1;
    final totalLevels = levels.length;

    final difficult = gameLevels.sections
        .firstWhere(
          (e) => e.levels.contains(level),
        )
        .difficulty;

    final color = getColorByDifficult(difficult);

    return FText(
      "$levelIndex/$totalLevels",
      strokeColor: color.brighten(0.5).darken(0.5),
      strokeWidth: 4,
      textStyle: const TextStyle(
        fontSize: 28,
        wordSpacing: 24,
      ),
    );
  }
}
