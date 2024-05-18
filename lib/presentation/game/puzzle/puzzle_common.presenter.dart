// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:flags/core/extensions/num.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/enums/game_difficult.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flags/features/onboarding/onboarding.service.dart';
import 'package:flags/features/vibration/vibration.provider.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/scallable_emblem.dart';
import 'package:flags/presentation/game/puzzle/generators/easy.dart';
import 'package:flags/presentation/game/puzzle/generators/extra_hard.dart';
import 'package:flags/presentation/game/puzzle/generators/hard.dart';
import 'package:flags/presentation/game/puzzle/generators/medium.dart';
import 'package:flags/presentation/game/puzzle/generators/super_easy.dart';
import 'package:flags/presentation/game/puzzle/handlers/game_objects_draggable.dart';
import 'package:flags/presentation/game/puzzle/onboarding/colored_part/colored_object.showcase_step_1.dart';
import 'package:flags/presentation/game/puzzle/onboarding/common_object/common_object.showcase.dart';
import 'package:flags/presentation/game/puzzle/onboarding/emblem/emblem_object.showcase_step_1.dart';
import 'package:flags/presentation/game/puzzle/onboarding/showcase.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/presentation/game/puzzle/validators/validator.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/screens/games/components/heart_tries/heart_tries.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:flags/screens/games/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/screens/games/puzzle/dialogs/complete_continent.dialog.dart';
import 'package:flags/screens/games/puzzle/dialogs/lose.dialog.dart';
import 'package:flags/screens/games/puzzle/dialogs/menu.dialog.dart';
import 'package:flags/screens/games/puzzle/dialogs/winner.dialog.dart';
import 'package:flags/screens/games/puzzle/scene_components/emblem.dart';
import 'package:flags/screens/games/puzzle/views/board.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:state_manager/state_manager.dart';

abstract interface class IPuzzleCommonModePresenter<S extends PuzzleGameState>
    extends Listenable
    with StateMixin<S>, ProcessedObjectFocusHandler
    implements IDisposable {
  PuzzleGameShowcase get showcase;

  GameLevel get level;

  RenderBoxExposer get flagExposer;

  bool handleGameObject(Vector2 position, ProcessGameObject object);

  AnimationController get shakeAnimation;

  IEmblemConfirmationController get emblemConfirmationView;

  PartsBoardState get boardController;

  HeartTriesState get heartTriesState;

  void tryRemoveFocussedEmblem();

  void tryPlaceFocussedEmblem();

  void openMenu();

  void skipLevel();
}

class PuzzleCommonModePresenterImpl extends GetxController
    with
        StateMixin<PuzzleGameState>,
        GetSingleTickerProviderStateMixin,
        ProcessedObjectFocusHandler
    implements IPuzzleCommonModePresenter<PuzzleGameState> {
  // SHOWCASE

  final IOnboardingService onboardingService = IOnboardingService.I;

  @override
  final PuzzleGameShowcase showcase = PuzzleGameShowcase();

  // ________

  final BuildContext context;
  late final IAudioController audioController = AudioProvider.of(context);
  late final vibrationService = PhoneVibrationProvider.of(context);

  ILevelsPickerPresenter get levelsPresenter => ILevelsPickerPresenter.i;

  ILevelsService get levelsService => ILevelsService.I;

  IEmblemsService get emblemsService => IEmblemsService.I;

  final GamesFactoryPageParams params;

  PuzzleCommonModePresenterImpl(
    this.context, {
    required this.params,
  })  : emblemConfirmationView = EmblemConfirmationWidgetState(),
        boardController = PartsBoardState(),
        heartTriesState = HeartTriesState(
          tries: 3,
        );

  int gameSeed = -1;

  @override
  late final AnimationController shakeAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  @override
  HeartTriesState heartTriesState;

  @override
  final IEmblemConfirmationController emblemConfirmationView;

  @override
  final PartsBoardState boardController;

  @override
  RenderBoxExposer flagExposer = RenderBoxExposer();

  @override
  GameLevel get level => params.level;

  @override
  Future<void> onInit() async {
    super.onInit();

    boardController.initState();
    emblemConfirmationView.initState();
    heartTriesState.initState();

    change(
      SuccessStatus(
        PuzzleGameState(
          level: params.level,
          difficult: params.difficult,
          boardObjects: [],
          flagFitValue: 1,
        ),
      ),
    );
    await preInitialization();
    super.onInit();

    await initialization();
    tryShowShowcases();
  }

  void tryShowShowcases() {
    if (this is IPuzzleFastModePresenter) {
      return;
    }
    showcase.show(
      [showcase.showcaseCommonObject],
      "puzzle.common_object",
    );

    showcase.show(
      [showcase.emblemObjectStep1],
      "puzzle_emblem_object",
    );

    showcase.show(
      [showcase.coloredObjectStep1],
      "puzzle_colored_object_1",
    );
  }

  Future<void> preInitialization() async {
    final savedLevel = levelsService.getLevelData(
      levelId: params.level.id,
      continent: params.continentType,
      gameMode: params.gameMode,
    );

    if (savedLevel == null) {
      final seed = Random().nextInt(int32MaxValue);

      levelsService.saveLevel(
        levelId: params.level.id,
        completed: params.level.completed,
        continent: params.continentType,
        gameMode: params.gameMode,
        seed: seed,
      );

      gameSeed = seed;
    } else {
      if (savedLevel.seed == -1) {
        final seed = Random().nextInt(int32MaxValue);
        levelsService.saveLevel(
          levelId: params.level.id,
          completed: params.level.completed,
          continent: params.continentType,
          gameMode: params.gameMode,
          seed: seed,
        );
        gameSeed = seed;
      } else {
        gameSeed = savedLevel.seed;
      }
    }

    flagExposer.renderBox.addListener(onFlagBuilt);
  }

  @override
  void dispose() {
    flagExposer.renderBox.removeListener(onFlagBuilt);
    super.dispose();
  }

  @override
  void onClose() {
    shakeAnimation.dispose();
  }

  Future<void> initialization() async {
    final parts = await generateBoardParts();
    state.boardObjects.clear();
    state.boardObjects.addAll(parts);
  }

  void onFlagBuilt() {
    final renderBox = flagExposer.renderBox.value!;

    state.flagFitValue = renderBox.size.width / state.level.value.flag.size.x;
  }

  Future<void> placeObject(ProcessGameObject object) async {
    var sceneObject = state.boardObjects.firstWhereOrNull((e) {
      return e.object.key == object.key;
    });

    if (object is EmblemPart) {
      sceneObject = state.boardObjects.firstWhereOrNull((e) {
        return e.object.uniqueName == object.uniqueName;
      });
    }

    sceneObject?.setActive(false);

    state.placedObjects.add(object);

    unfocusObject();
    tryCompleteLevel();

    await audioController.playSfx(GameSfx.correctlyObjectPlacing);
  }

  void tryCompleteLevel() {
    final flagObjects = state.level.value.flag.objects;

    if (flagObjects.length == state.placedObjects.length) {
      onLevelCompleted();
    }
  }

  void onLevelCompleted() {
    levelsService.saveLevel(
      levelId: state.level.value.id,
      completed: true,
      continent: params.continentType,
      gameMode: params.gameMode,
      seed: -1,
    );

    final NextLevelData data =
        levelsPresenter.getNextLevelFromCurrent(state.level.value);

    final level = state.level.value.copyWith();

    final emblems = [...level.flag.emblems]..removeWhere(
        (e) => emblemsService.isOpened(e.name),
      );

    final isLastLevelInSection =
        data.section?.difficulty != state.difficult.value;

    if (data.section != null) {
      PuzzleWinnerDialog(
        level: level,
        nextLevel: data.level,
        isLastLevelInSection: isLastLevelInSection,
        onExitPressed: () {
          QR.back();
          QR.back();
        },
        onNextLevelPressed: () async {
          QR.back();
          await EasyLoading.show();

          await openNextLevel(data);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await EasyLoading.dismiss();
          });
        },
        emblems: emblems,
      ).showModal(
        barrierDismissible: false,
      );
    }

    state.level.value.completeLevel();

    if (!level.completed) {
      if (isLastLevelInSection) {
        audioController.playSfx(GameSfx.sectionCompleted);
      }
      IAppPresenter.I.gameState.addMoney(level.id);

      if (level.flag.emblems.isNotEmpty) {
        for (final emblem in level.flag.emblems) {
          emblemsService.saveEmblem(emblem.name);
        }
      }
    }

    if (data.level != null) {
      if (!data.level!.opened) {
        data.level?.openLevel();
      }
    }

    levelsPresenter.statusRx.notifyListeners();

    if (data.section == null) {
      PuzzleCompleteContinentDialog(
        continent: params.continentType,
        onExit: () {
          QR.back();
          QR.back();
        },
      ).showModal(
        barrierDismissible: false,
      );
    }
  }

  Future<void> openNextLevel(NextLevelData data) async {
    resetLevelState();

    state.difficult.value = data.section!.difficulty;
    state.level.value = data.level!;

    final parts = await generateBoardParts();

    state.boardObjects.clear();

    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    state.boardObjects.addAll(parts);

    tryShowShowcases();
  }

  @override
  bool handleGameObject(Vector2 position, ProcessGameObject object) {
    ProcessGameObject gameObject = object;

    if (gameObject is ScalableEmblemPart) {
      final emblemFromFlag = IterableExt(state.flag.emblems).firstOrNull;

      if (emblemFromFlag != null) {
        gameObject = gameObject.copyWith(
          key: emblemFromFlag.key,
          previousMustBePlaced: emblemFromFlag.previousMustBePlaced,
        );
      }

      final isPreviousPlaced = gameObject.previousMustBePlaced?.every(
            (e) => state.placedObjects.map((e) => e.uniqueName).contains(e),
          ) ??
          true;

      if (!isPreviousPlaced) {
        onIncorrectPlacing();
        return false;
      }

      gameObject = DraggableEmblemPart.fromEmblem(
        gameObject.copyWith(
          key: gameObject.key,
          position: position / state.flagFitValue,
        ),
        scales: gameObject.scales,
      );

      state.placedObjects.add(gameObject);
      final object = state.boardObjects.firstWhere((e) {
        return e.object.uniqueName == gameObject.uniqueName;
      });

      object.setActive(false);

      return true;
    }

    final availableObject = PuzzleObjectPlacingHandler().handle(
      object: gameObject,
      flag: state.level.value.flag,
      placedObjects: state.placedObjects,
      position: position,
      fitValue: state.flagFitValue,
    );

    if (availableObject != null) {
      placeObject(availableObject);
    } else {
      onIncorrectPlacing();
    }

    return availableObject != null;
  }

  Future<void> onIncorrectPlacing() async {
    await audioController.playSfx(GameSfx.incorrectObjectPlacing);
    vibrationService.vibrate();
    shakeAnimation.forward(from: 0);

    if (!IAppPresenter.I.appPreferences.data.isDebugMode) {
      heartTriesState.removeOneHeart();
    }

    if (heartTriesState.isOver()) {
      onGameOver();
    }
  }

  Future<void> onGameOver() async {
    await audioController.playSfx(GameSfx.gameLoose);
    await audioController.pauseBgm();
    await PuzzleLoseDialog(
      onRestart: onRestart,
      onExit: onGameExit,
    ).showModal(
      barrierDismissible: false,
    );
  }

  void resetLevelState() {
    for (final element in state.boardObjects.value) {
      element.dispose();
    }
    state.boardObjects.clear();

    emblemConfirmationView.hide();
    focusedObject.value = null;
    heartTriesState.refresh();
    state.placedObjects.clear();

    boardController.toggleDraggingStatus(true);
  }

  Future<void> onRestart() async {
    await restartLevel();
    await QR.back();
  }

  Future<void> restartLevel() async {
    await audioController.resumeBgm();
    final level = state.level.value;
    state.boardObjects.clear();

    await Future.delayed(
      const Duration(milliseconds: 10),
    );

    FlutterEngine.schedulePostFrameCallback((timeStamp) async {
      resetLevelState();
      final seed = Random().nextInt(int32MaxValue);

      levelsService.saveLevel(
        levelId: level.id,
        completed: level.completed,
        continent: params.continentType,
        gameMode: params.gameMode,
        seed: seed,
      );

      gameSeed = seed;

      final parts = await generateBoardParts();

      state.boardObjects.addAll(parts);
    });
  }

  List<GameLevel> get levels => ILevelsPickerPresenter.i.levels.levels;

  @override
  void onObjectFocusAdded(Object object) {
    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      boardController.toggleDraggingStatus(false);
    });
  }

  @override
  void onObjectFocusRemoved(Object object) {
    emblemConfirmationView.hide();

    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      boardController.toggleDraggingStatus(true);
    });
  }

  @override
  void tryPlaceFocussedEmblem() {
    final sceneObject = focusedObject.value as EmblemSceneObjectState?;
    final focussedObject = sceneObject?.widget.gameObject;

    if (focussedObject != null) {
      final object = focussedObject.toEmblemPart();

      object.positionRx.value = sceneObject!.positionRx.value;
      object.rotationRx.value = sceneObject.rotationRx.value;
      object.scaleRx.value =
          sceneObject.scaleConverter(sceneObject.scaleRx.value);

      final flagObject = state.level.value.flag.objects.firstWhereOrNull(
        (e) => e.uniqueName == object.uniqueName,
      ) as EmblemPart?;

      if (flagObject == null) {
        onIncorrectPlacing();
        return;
      }

      final fitValue = state.flagFitValue;

      final fittedFlagObjectPosition = flagObject.position;

      final isCorrectDistance =
          fittedFlagObjectPosition.distanceTo(object.position) <
              (15 / fitValue);

      var isCorrectRotation = object.rotation == flagObject.rotation;

      if (!flagObject.emblem.identicalRotation) {
        if (flagObject.emblem.symmetrical180) {
          final rotation180 = (flagObject.rotation + pi) % (2 * pi);
          isCorrectRotation =
              isCorrectRotation || object.rotation == rotation180;
        }

        if (flagObject.emblem.symmetrical90) {
          final double rotationDifference =
              (object.rotation - flagObject.rotation).abs();
          final double rotationRemainder = rotationDifference % (pi / 2);

          isCorrectRotation = isCorrectRotation ||
              rotationRemainder < 1e-9 ||
              (pi / 2 - rotationRemainder) < 1e-9;
        }
      } else {
        isCorrectRotation = true;
      }

      final isCorrectScale = object.scale == flagObject.scale;

      if (isCorrectDistance && isCorrectRotation && isCorrectScale) {
        state.placedObjects.removeWhere((e) => e is DraggableEmblemPart);
        placeObject(flagObject);
      } else {
        onIncorrectPlacing();
      }
    }
  }

  @override
  void tryRemoveFocussedEmblem() {
    final focussedObject = focusedObject.value;
    if (focussedObject != null && focussedObject is GameObjectWidgetState) {
      final widget = focussedObject;

      state.boardObjects
          .firstWhere(
            (e) => e.object.uniqueName == widget.gameObject.uniqueName,
          )
          .setActive(true);
      state.placedObjects.removeWhere(
        (e) => e.uniqueName == widget.gameObject.uniqueName,
      );
      onObjectFocusRemoved(focussedObject);
      focusedObject.value = null;
    }
  }

  @override
  Future<void> openMenu() async {
    await onMenuOpened();

    await PuzzleMenuDialog(
      onRestart: onRestart,
      onExit: onGameExit,
      seed: gameSeed,
    ).showModal();

    await onMenuClosed();
  }

  void onGameExit() {
    QR.back();
    QR.back();
  }

  Future<void> onMenuOpened() async {}

  Future<void> onMenuClosed() async {}

  @override
  void skipLevel() {
    onLevelCompleted();
  }

  double getScoreMultiplier(GameDifficult difficult) => switch (difficult) {
        GameDifficult.superEasy => 1,
        GameDifficult.easy => 1.5,
        GameDifficult.medium => 2,
        GameDifficult.hard => 2.5,
        GameDifficult.extraHard => 3,
      };

  Future<List<BoardItem<ProcessGameObject>>> generateBoardParts() async {
    final levels = FactoryGameContinent.allLevels;

    final generator = switch (state.difficult.value) {
      GameDifficult.superEasy => PuzzleSuperEasyGenerator.new,
      GameDifficult.easy => PuzzleEasyGenerator.new,
      GameDifficult.medium => PuzzleMediumGenerator.new,
      GameDifficult.hard => PuzzleHardGenerator.new,
      GameDifficult.extraHard => PuzzleExtraHardGenerator.new,
    };

    final generatedObjects = await generator(levels: levels).generate(
      state.level.value.flag,
      Random(gameSeed),
    );

    final parts = [
      ...generatedObjects.map(
        (e) => BoardItem(object: e),
      ),
    ];

    if (this is! IPuzzleFastModePresenter) {
      if (showcase.isCompleted("puzzle.common_object")) {
        final flagPartIndex = parts.indexWhere(
          (e) => state.level.value.flag.objects.whereType<PathGameObject>().any(
                (element) => e.object.uniqueName == element.uniqueName,
              ),
        );

        if (flagPartIndex != -1) {
          final object = parts[flagPartIndex];

          parts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleCommonObjectShowcase(
              showcaseKey: showcase.showcaseCommonObject,
              flagExposer: flagExposer,
              child: instance,
            ),
          );
        }
      }

      if (!showcase.isCompleted("puzzle_emblem_object")) {
        final flagPartIndex = parts.indexWhere(
          (e) => state.level.value.flag.objects.whereType<EmblemPart>().any(
                (element) => e.object.uniqueName == element.uniqueName,
              ),
        );

        if (flagPartIndex != -1) {
          final object = parts[flagPartIndex];

          parts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleEmblemObjectStep1Showcase(
              showcaseKey: showcase.emblemObjectStep1,
              flagExposer: flagExposer,
              child: instance,
            ),
          );
        }
      }

      if (!showcase.isCompleted("puzzle_colored_object_1")) {
        final flagPartIndex = parts.indexWhere(
          (e) => e.object is ColoredPart,
        );

        if (flagPartIndex != -1) {
          final object = parts[flagPartIndex];

          parts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleColoredObjectStep1Showcase(
              showcaseKey: showcase.coloredObjectStep1,
              onTap: () {
                showcase.complete("puzzle_colored_object_1");
              },
              child: instance,
            ),
          );
        }
      }
    }

    return parts;
  }
}
