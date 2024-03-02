// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:armar/armar.dart';
import 'package:armar/state_management/get_utils/src/extensions/internacionalization.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/enums/game_difficult.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/scallable_emblem.dart';
import 'package:flags/presentation/game/puzzle/generators/easy.dart';
import 'package:flags/presentation/game/puzzle/generators/extra_hard.dart';
import 'package:flags/presentation/game/puzzle/generators/hard.dart';
import 'package:flags/presentation/game/puzzle/generators/medium.dart';
import 'package:flags/presentation/game/puzzle/generators/super_easy.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/presentation/game/puzzle/validators/validator.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:flags/screens/games/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../core/extensions/num.dart';
import '../../../core/flutter_engine.dart';
import '../../../domain/services/levels/levels.service.dart';
import '../../../screens/games/components/heart_tries/heart_tries.dart';
import '../../../screens/games/puzzle/dialogs/lose.dialog.dart';
import '../../../screens/games/puzzle/dialogs/menu.dialog.dart';
import '../../../screens/games/puzzle/dialogs/winner.dialog.dart';
import '../../../screens/games/puzzle/scene_components/emblem.dart';
import '../../../screens/games/puzzle/views/board.dart';
import '../../../uikit/game_widgets/game_widgets.dart';
import 'entities/board_item.dart';
import 'handlers/game_objects_draggable.dart';

abstract interface class IPuzzleCommonModePresenter
    with StateMixin<PuzzleGameState>, ProcessedObjectFocusHandler {
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
    implements IPuzzleCommonModePresenter {
  ILevelsPickerPresenter get levelsPresenter => ILevelsPickerPresenter.i;

  ILevelsService get levelsService => ILevelsService.I;

  IEmblemsService get emblemsService => IEmblemsService.I;

  final GamesFactoryPageParams params;

  PuzzleCommonModePresenterImpl({
    required this.params,
  })  : emblemConfirmationView = EmblemConfirmationWidgetState()..initState(),
        boardController = PartsBoardState()..initState(),
        heartTriesState = HeartTriesState(
          tries: 3,
        )..initState();

  int _seed = -1;

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
  void onInit() async {
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

      _seed = seed;
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
        _seed = seed;
      } else {
        _seed = savedLevel.seed;
      }
    }

    flagExposer.renderBox.stream.listen(onFlagBuilt);

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
    super.onInit();

    await initialization();
  }

  @override
  onClose() {
    shakeAnimation.dispose();
  }

  Future<void> initialization() async {
    state.boardObjects.run(() {
      state.boardObjects.clear();
      state.boardObjects.addAll(_generateParts());
    });
  }

  void onFlagBuilt(RenderBox? event) {
    state.flagFitValue =
        flagExposer.renderBox.value!.size.width / state.level.value.flag.size.x;
  }

  Future<void> placeObject(ProcessGameObject object) async {
    state.placedObjects.add(object);

    state.boardObjects.firstWhere((e) {
      return e.object.uniqueName == object.uniqueName;
    }).setActive(false);

    unfocusObject();
    tryCompleteLevel();
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

    NextLevelData data =
        levelsPresenter.getNextLevelFromCurrent(state.level.value);

    final level = state.level.value.copyWith();

    final emblems = [...level.flag.emblems]..removeWhere(
        (e) => emblemsService.isOpened(e.name),
      );
    PuzzleWinnerDialog(
      level: level,
      nextLevel: data.level,
      isLastLevelInSection: data.section?.difficulty != state.difficult.value,
      onExitPressed: () {
        QR.back();
        QR.back();
      },
      onNextLevelPressed: () async {
        QR.back();
        await openNextLevel(data);
      },
      emblems: emblems,
    ).showModal(
      barrierDismissible: false,
    );

    state.level.value.completeLevel();

    if (!level.completed) {
      if (level.flag.emblems.isNotEmpty) {
        for (var emblem in level.flag.emblems) {
          emblemsService.saveEmblem(emblem.name);
        }
      }
    }

    if (data.level != null) {
      if (!data.level!.opened) {
        data.level?.openLevel();
      }
    }

    levelsPresenter.statusRx.notify();
  }

  Future<void> openNextLevel(NextLevelData data) async {
    await EasyLoading.show();
    resetLevelState();

    state.difficult.value = data.section!.difficulty;
    state.level.value = data.level!;

    state.boardObjects.run(() {
      state.boardObjects.clear();
      state.boardObjects.addAll(_generateParts());
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await EasyLoading.dismiss();
    });
  }

  @override
  bool handleGameObject(Vector2 position, ProcessGameObject object) {
    ProcessGameObject gameObject = object;

    if (gameObject is ScalableEmblemPart) {
      final emblemFromFlag = state.flag.emblems.firstOrNull;

      if (emblemFromFlag != null) {
        gameObject = gameObject.copyWith(
          previousMustBePlaced: emblemFromFlag.previousMustBePlaced,
        );
      }

      final isPreviousPlaced = gameObject.previousMustBePlaced?.every(
            (e) => state.placedObjects.map((e) => e.name).contains(e),
          ) ??
          true;

      if (!isPreviousPlaced) {
        onIncorrectPlacing();
        return false;
      }

      gameObject = DraggableEmblemPart.fromEmblem(
        gameObject.copyWith(
          position: position / state.flagFitValue,
        ),
        correctScaleIndex: gameObject.correctScaleIndex,
        scales: gameObject.scales,
      );

      state.placedObjects.add(gameObject);
      state.boardObjects.firstWhere((e) {
        return e.object.uniqueName == gameObject.uniqueName;
      }).setActive(false);

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

  void onIncorrectPlacing() {
    shakeAnimation.forward(from: 0);
    // heartTriesState.removeOneHeart();

    if (heartTriesState.isOver()) {
      PuzzleLoseDialog(
        onRestart: () async {
          restartLevel();
          await QR.back();
        },
        onExit: onGameExit,
      ).showModal();
    }
  }

  void resetLevelState() {
    emblemConfirmationView.hide();
    focusedObject.value = null;
    heartTriesState.refresh();
    state.placedObjects.run(() {
      state.placedObjects.value.clear();
    });

    boardController.toggleDraggingStatus(true);
  }

  void restartLevel() async {
    resetLevelState();

    for (var e in state.boardObjects.value) {
      e.setActive(true);
    }
  }

  void onGameExit() {
    QR.back();
  }

  List<BoardItem> _generateParts() {
    final generator = switch (state.difficult.value) {
      GameDifficult.superEasy => PuzzleSuperEasyGenerator(),
      GameDifficult.easy => PuzzleEasyGenerator(),
      GameDifficult.medium => PuzzleMediumGenerator(),
      GameDifficult.hard => PuzzleHardGenerator(),
      GameDifficult.extraHard => PuzzleExtraHardGenerator(),
    };

    return [
      ...generator
          .generate(
            state.level.value.flag,
            Random(_seed),
          )
          .map(
            (e) => BoardItem(object: e),
          ),
    ];
  }

  @override
  void onObjectFocusAdded(dynamic object) {
    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      boardController.toggleDraggingStatus(false);
    });
  }

  @override
  void onObjectFocusRemoved(dynamic object) {
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

      object.position = sceneObject!.positionRx.value;
      object.rotation = sceneObject.rotationRx.value;
      object.scale = sceneObject.scaleConverter(sceneObject.scaleRx.value);

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
  void openMenu() async {
    await onMenuOpened();

    await PuzzleMenuDialog(
      onRestart: () {
        restartLevel();
        QR.back();
      },
      onExit: () {
        QR.back();
        QR.back();
      },
    ).showModal();

    await onMenuClosed();
  }

  Future<void> onMenuOpened() async {}

  Future<void> onMenuClosed() async {}

  @override
  void skipLevel() {
    onLevelCompleted();
  }
}
