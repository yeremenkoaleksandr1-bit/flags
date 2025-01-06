import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/entities/game/game_levels/game_levels_section.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/features/levels_picker/presentation/features/color_by_difficult.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentLevelIndex extends StatelessWidget {
  const CurrentLevelIndex({super.key, required this.level});

  final GameLevel level;

  @override
  Widget build(BuildContext context) {
    final ILevelsPickerCubit levelsPickerCubit =
        context.read<ILevelsPickerCubit>();

    final List<GameLevelsSection> sections = levelsPickerCubit.state.maybeWhen(
      success: (state) => state.sections,
      orElse: () => [],
    );

    final levels = sections.map((e) => e.levels).expand((e) => e).toList();

    final levelIndex = levels.indexWhere((e) => e == level) + 1;
    final totalLevels = levels.length;

    final difficult = sections
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
