import 'package:armar/armar.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presenters/levels_picker/state/levels_page.state.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../domain/entities/game/game.dart';
import 'route_params.dart';

class NextLevelData {
  final GameLevel? level;
  final GameLevelsSection? section;

  NextLevelData({
    required this.level,
    required this.section,
  });
}

abstract interface class ILevelsPickerPresenter
    with StateMixin<LevelsPickerState> {
  static ILevelsPickerPresenter get i =>
      Get.find<ILevelsPickerPresenter>(tag: "single");

  GameLevels get levels;

  NextLevelData getNextLevelFromCurrent(
    GameLevel currentLevel,
  );

  void onLevelPicked(
    GameLevel level,
    GameDifficult difficult,
    GameStyleType gameStyleType,
  );
}

class LevelsPickerPresenterImpl extends GetxController
    with StateMixin<LevelsPickerState>
    implements ILevelsPickerPresenter {
  final LevelsPickerRouteParams params;

  LevelsPickerPresenterImpl({
    required this.params,
  });

  @override
  GameLevels get levels => state.levels;

  @override
  void onInit() async {
    final levelService = ILevelsService.I;

    final levels = FactoryGameContinent().create(params.continentType);

    var previousLevelCompleted = true;

    for (var level in levels.levels) {
      if (previousLevelCompleted) {
        final levelData = levelService.getLevelData(
          levelId: level.id,
          continent: params.continentType,
          gameMode: params.gameProcessType,
        );

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

    change(
      SuccessStatus(
        LevelsPickerState(
          levels: levels,
        ),
      ),
    );

    super.onInit();
  }

  @override
  void onLevelPicked(
    GameLevel level,
    GameDifficult difficult,
    GameStyleType gameStyleType,
  ) {
    if (!level.opened) return;

    QR.toName(
      Routes.gameProcessFactory,
      params: {
        'data': GamesFactoryPageParams(
          level: level,
          difficult: difficult,
          gamesType: gameStyleType,
          gameMode: params.gameProcessType,
          continentType: params.continentType,
        ),
      },
    );
  }

  @override
  NextLevelData getNextLevelFromCurrent(GameLevel currentLevel) {
    final allLevels = levels.levels;

    int currentIndex = allLevels.indexOf(currentLevel);

    if (currentIndex != -1 && currentIndex < allLevels.length - 1) {
      final nextLevel = allLevels[currentIndex + 1];

      final section = levels.sections.firstWhere(
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
  }
}
