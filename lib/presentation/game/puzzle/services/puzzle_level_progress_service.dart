import 'dart:math';

import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';

final class PuzzleLevelProgressService {
  const PuzzleLevelProgressService();

  int resolveSeed({
    required GameLevelsCubit levelsCubit,
    required ContinentType continentType,
    required GameLevel level,
  }) {
    final savedLevel = levelsCubit.getLevelData(continentType, level.id);
    if (savedLevel == null || savedLevel.seed == -1) {
      final seed = _createSeed();
      levelsCubit.saveLevel(
        id: level.id,
        data: LevelProcessData(
          completed: level.completed,
          seed: seed,
        ),
        continent: continentType,
      );
      return seed;
    }

    return savedLevel.seed;
  }

  void saveCompletedLevel({
    required GameLevelsCubit levelsCubit,
    required ContinentType continentType,
    required int levelId,
  }) {
    levelsCubit.saveLevel(
      continent: continentType,
      id: levelId,
      data: const LevelProcessData(
        completed: true,
        seed: -1,
      ),
    );
  }

  int createNextSeed({
    required GameLevelsCubit levelsCubit,
    required ContinentType continentType,
    required GameLevel level,
  }) {
    final seed = _createSeed();
    levelsCubit.saveLevel(
      continent: continentType,
      id: level.id,
      data: LevelProcessData(
        completed: level.completed,
        seed: seed,
      ),
    );
    return seed;
  }

  int _createSeed() => Random().nextInt(2147483647);
}
