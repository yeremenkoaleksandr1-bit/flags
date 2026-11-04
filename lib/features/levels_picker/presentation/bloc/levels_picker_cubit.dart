import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/prefabs/levels/levels.dart';

class NextLevelData {
  final GameLevel? level;
  final GameLevelsSection? section;

  NextLevelData({
    required this.level,
    required this.section,
  });
}

abstract interface class ILevelsPickerCubit
    extends DynamicStatedBlocStream<GameContinentData> {
  ContinentType get continentType;

  GameProcessType get gameProcessType;

  NextLevelData getNextLevelFromCurrent(
    GameLevel currentLevel,
  );
}

class LevelsPickerCubitImpl extends StatedCubit<GameContinentData>
    implements ILevelsPickerCubit {
  final GameLevelsCubit levelsCubit;

  @override
  final ContinentType continentType;
  @override
  final GameProcessType gameProcessType;

  LevelsPickerCubitImpl({
    required this.levelsCubit,
    required this.continentType,
    required this.gameProcessType,
  });

  @override
  Future<void> onInit() async {
    final GameContinentData gameLevelsData =
        FactoryGameContinent().create(continentType);

    for (final e in gameLevelsData.levels) {
      e.opened = false;
    }

    var previousLevelCompleted = true;

    for (final level in gameLevelsData.levels) {
      final levelData = levelsCubit.getLevelData(
        continentType,
        level.id,
      );

      if (previousLevelCompleted) {
        if (levelData != null) {
          level.opened = true;
          level.completed = levelData.completed;
          previousLevelCompleted = level.completed;
        } else {
          level.opened = true;
          previousLevelCompleted = false;
        }
      } else {
        break;
      }
    }

    emit(
      SuccessState(
        gameLevelsData,
      ),
    );

    super.onInit();
  }

  @override
  NextLevelData getNextLevelFromCurrent(GameLevel currentLevel) {
    return state.maybeWhen(success: (state) {
      final levels = state.levels;
      final int currentIndex = levels.indexOf(currentLevel);

      if (currentIndex != -1 && currentIndex < levels.length - 1) {
        final nextLevel = levels[currentIndex + 1];

        final section = state.sections.firstWhere(
          (e) => e.levels.any(
            (e) => e == nextLevel,
          ),
        );

        return NextLevelData(
          level: nextLevel,
          section: section,
        );
      } else {
        return NextLevelData(
          level: null,
          section: null,
        );
      }
    }, orElse: () {
      return NextLevelData(
        level: null,
        section: null,
      );
    });
  }
}
