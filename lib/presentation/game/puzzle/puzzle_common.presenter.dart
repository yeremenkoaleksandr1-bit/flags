// ignore_for_file: invalid_use_of_protected_member, avoid_void_async

import 'dart:async';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:collection/collection.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/enums/game_difficult.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_cubit.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flags/features/games/presentation/components/heart_tries/heart_tries.dart';
import 'package:flags/features/games/presentation/games_factory.page.dart';
import 'package:flags/features/games/presentation/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/complete_continent.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/lose.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/flag_game_unlocked.dialog.dart';
import 'package:flags/features/flag_games/flag_game_unlocks.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/menu.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/winner.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/emblem.dart';
import 'package:flags/features/games/presentation/puzzle/views/board.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/logger.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';
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
import 'package:flags/presentation/game/puzzle/services/puzzle_level_progress_service.dart';
import 'package:flags/presentation/game/puzzle/services/puzzle_object_placement_service.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


/// Разлёт деталей при проигрыше (false — выключить).
const bool kPuzzleScatterEnabled = true;

class PuzzleCommonModeCubit extends StatedCubit<PuzzleGameState>
    with ProcessedObjectFocusHandler {
  final IAppCubit appCubit;

  final TickerProvider vsync;

  // SHOWCASE

  final IOnboardingService onboardingService;

  final PuzzleGameShowcase showcase;

  // ________

  final BuildContext context;

  final IAudioCubit audioCubit;

  final IVibrationCubit vibrationCubit;
  final MonetizationCubit monetizationCubit;

  final ILevelsPickerCubit levelsCubit;

  final GameLevelsCubit levelsService;

  IEmblemsService get emblemsService => appCubit.emblemsService;

  final GamePreferencesCubit gamePreferences;

  final GamesFactoryPageParams params;
  final PuzzleLevelProgressService levelProgressService;
  final PuzzleObjectPlacementService placementService;

  PuzzleCommonModeCubit(
    this.context,
    this.vsync, {
    required this.params,
    required this.appCubit,
    required this.levelsCubit,
    required this.onboardingService,
    this.levelProgressService = const PuzzleLevelProgressService(),
    this.placementService = const PuzzleObjectPlacementService(),
  }) : audioCubit = context.read<IAudioCubit>(),
       vibrationCubit = context.read<IVibrationCubit>(),
       monetizationCubit = context.read<MonetizationCubit>(),
       levelsService = context.read<GameLevelsCubit>(),
       gamePreferences = context.read<GamePreferencesCubit>(),
       showcase = PuzzleGameShowcase(service: onboardingService),
       emblemConfirmationView = EmblemConfirmationWidgetState(),
       boardController = PartsBoardState(),
       heartTriesState = HeartTriesState(tries: 3);

  int gameSeed = -1;

  late final AnimationController shakeAnimation = AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 100),
  );

  /// Проигрыш: поставленные на флаг детали разлетаются и падают (0 → 1).
  late final AnimationController scatterAnimation = AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 1400),
  );

  HeartTriesState heartTriesState;

  final IEmblemConfirmationController emblemConfirmationView;

  final PartsBoardState boardController;

  RenderBoxExposer flagExposer = RenderBoxExposer();

  bool _isGameOverShown = false;

  GameLevel get level => params.level;

  @override
  Future<void> onInit() async {
    super.onInit();

    boardController.initState();
    emblemConfirmationView.initState();
    heartTriesState.initState();

    emit(
      SuccessState(
        PuzzleGameState(
          level: params.level,
          difficult: params.difficult,
          boardObjects: const [],
          flagFitValue: 1,
          placedObjects: const [],
        ),
      ),
    );
    await preInitialization();
    await initialization();
  }

  Future<void> preInitialization() async {
    gameSeed = levelProgressService.resolveSeed(
      levelsCubit: levelsService,
      continentType: params.continentType,
      level: params.level,
    );
    flagExposer.renderBox.addListener(onFlagBuilt);
  }

  @override
  Future<void> close() async {
    _isGameOverShown = false;
    showcase.dismiss();
    shakeAnimation.dispose();
    scatterAnimation.dispose();

    flagExposer.renderBox.removeListener(onFlagBuilt);

    disposeProcessedObjectFocusHandler();

    await super.close();
  }

  Future<void> initialization() async {
    final parts = await generateBoardParts(level, params.difficult);

    state.whenOrNull(
      success: (state) {
        emit(
          SuccessState(
            state.copyWith(
              boardObjects: [...prepareShowcaseObjects(parts, level)],
            ),
          ),
        );
      },
    );
  }

  void onFlagBuilt() {
    state.whenOrNull(
      success: (state) {
        final renderBox = flagExposer.renderBox.value!;
        final widthFit = renderBox.size.width / state.level.flag.size.x;
        final heightFit = renderBox.size.height / state.level.flag.size.y;

        emit(
          SuccessState(state.copyWith(flagFitValue: min(widthFit, heightFit))),
        );
      },
    );
  }

  Future<void> placeObject(ProcessGameObject object) async {
    state.whenOrNull(
      success: (state) {
        _applyPlacement(
          state,
          object,
          placedObjects: [...state.placedObjects, object],
        );
      },
    );
  }

  void _applyPlacement(
    PuzzleGameState state,
    ProcessGameObject object, {
    required List<ProcessGameObject> placedObjects,
  }) {
    final sceneObject = placementService.findSceneObject(
      boardObjects: state.boardObjects,
      object: object,
    );

    sceneObject?.setActive(false);

    emit(SuccessState(state.copyWith(placedObjects: placedObjects)));

    unfocusObject();
    tryCompleteLevel();

    unawaited(audioCubit.playSfx(GameSfx.correctlyObjectPlacing));
  }

  void tryCompleteLevel() {
    state.whenOrNull(
      success: (state) {
        final flagObjects = state.level.flag.objects;

        if (flagObjects.length == state.placedObjects.length) {
          onLevelCompleted(state);
        }
      },
    );
  }

  void onLevelCompleted(PuzzleGameState state) {
    final moneyReward = state.level.id;

    levelProgressService.saveCompletedLevel(
      levelsCubit: levelsService,
      continentType: params.continentType,
      levelId: state.level.id,
    );

    final NextLevelData data = levelsCubit.getNextLevelFromCurrent(state.level);

    final level = state.level.copyWith();

    final emblems = [...level.flag.emblems]
      ..removeWhere((e) => emblemsService.isOpened(e.name));

    final isLastLevelInSection = data.section?.difficulty != state.difficult;

    if (data.section != null) {
      PuzzleWinnerDialog(
        level: level,
        nextLevel: data.level,
        isLastLevelInSection: isLastLevelInSection,
        onExitPressed: (context) async {
          Navigator.of(context).pop();
          await monetizationCubit.consumePostLevelAdOpportunity();
          if (!this.context.mounted) return;
          await this.context.maybePop();
        },
        onNextLevelPressed: (context) async {
          Navigator.of(context).pop();
          await monetizationCubit.consumePostLevelAdOpportunity();
          await EasyLoading.show();

          await openNextLevel(data);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await EasyLoading.dismiss();
          });
        },
        onDoubleRewardPressed: (context) async {
          final rewarded = await monetizationCubit.claimDoubleReward();
          if (rewarded) {
            gamePreferences.addMoney(moneyReward);
          }

          return rewarded;
        },
        emblems: emblems,
      ).showModal(context, barrierDismissible: false);
    }

    state.level.completeLevel();

    // первая сборка флага, у которого есть своя игра, — открываем её
    if (!level.completed) {
      unawaited(_unlockFlagGame(level.flag.name));
    }

    if (!level.completed) {
      if (isLastLevelInSection) {
        audioCubit.playSfx(GameSfx.sectionCompleted);
      }

      gamePreferences.addMoney(level.id);

      if (level.flag.emblems.isNotEmpty) {
        for (final emblem in level.flag.emblems) {
          emblemsService.saveEmblem(emblem.name);
        }
      }

      monetizationCubit.registerLevelCompleted();
    }

    if (data.level != null) {
      if (!data.level!.opened) {
        data.level?.openLevel();
      }
    }

    //levelsCubit.statusRx.notifyListeners();

    if (data.section == null) {
      PuzzleCompleteContinentDialog(
        continent: params.continentType,
        onExit: (context) async {
          Navigator.of(context).pop();
          await monetizationCubit.consumePostLevelAdOpportunity();
          if (!this.context.mounted) return;
          await this.context.maybePop();
        },
      ).showModal(context, barrierDismissible: false);
    }
  }

  Future<void> openNextLevel(NextLevelData data) async {
    state.whenOrNull(
      success: (state) async {
        gameSeed = levelProgressService.createNextSeed(
          levelsCubit: levelsService,
          continentType: params.continentType,
          level: data.level ?? state.level,
        );
        resetLevelState();

        final level = data.level ?? state.level;
        final parts = await generateBoardParts(
          data.level ?? state.level,
          data.section?.difficulty ?? state.difficult,
        );

        emit(
          SuccessState(
            state.copyWith(
              level: data.level,
              difficult: data.section!.difficulty,
              placedObjects: [],
              boardObjects: [...prepareShowcaseObjects(parts, level)],
            ),
          ),
        );
      },
    );
  }

  bool handleGameObject(Vector2 position, ProcessGameObject object) {
    return state.maybeWhen(
      success: (state) {
        final availableObject = placementService.resolvePlacedObject(
          object: object,
          placedObjects: state.placedObjects,
          flag: state.level.flag,
          position: position,
          fitValue: state.flagFitValue,
        );

        if (availableObject != null) {
          if (availableObject is DraggableEmblemPart) {
            emit(
              SuccessState(
                state.copyWith(
                  placedObjects: [...state.placedObjects, availableObject],
                ),
              ),
            );
            placementService
                .findSceneObject(
                  boardObjects: state.boardObjects,
                  object: availableObject,
                )
                ?.setActive(false);
            return true;
          }

          placeObject(availableObject);
        } else {
          onIncorrectPlacing();
        }

        return availableObject != null;
      },
      orElse: () => false,
    );
  }

  Future<void> _unlockFlagGame(String flagName) async {
    if (!await FlagGameUnlocks.onPuzzleCompleted(flagName)) return;
    // поверх окна победы, когда оно уже появилось
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed || !context.mounted) return;
    await showFlagGameUnlockedDialog(context, flagName);
  }

  Future<void> onIncorrectPlacing() async {
    if (_isGameOverShown || isClosed) {
      return;
    }

    unawaited(audioCubit.playSfx(GameSfx.incorrectObjectPlacing));
    vibrationCubit.vibrate();
    shakeAnimation.forward(from: 0);

    heartTriesState.removeOneHeart();

    if (heartTriesState.isOver()) {
      onGameOver();
    }
  }

  Future<void> onGameOver() async {
    if (_isGameOverShown || isClosed || !context.mounted) {
      return;
    }

    _isGameOverShown = true;
    showcase.dismiss();

    if (isClosed || !context.mounted) {
      return;
    }

    unawaited(() async {
      await audioCubit.playSfx(GameSfx.gameLoose);
      await audioCubit.pauseBgm();
    }());

    // детали разлетаются с флага, и только потом реклама/окно проигрыша
    if (kPuzzleScatterEnabled) {
      boardController.toggleDraggingStatus(false);
      await scatterAnimation.forward(from: 0);
      if (isClosed || !context.mounted) return;
    }

    await monetizationCubit.onGameOverAdOpportunity();

    if (!context.mounted) return;

    await PuzzleLoseDialog(
      onRestart: onRestart,
      onExit: onGameExit,
    ).showModal(context, barrierDismissible: false);
    // окно закрыто — новые детали рисуются как обычно
    if (!isClosed) scatterAnimation.reset();
  }

  void resetLevelState() {
    _isGameOverShown = false;
    showcase.dismiss();
    state.whenOrNull(
      success: (state) {
        for (final element in state.boardObjects) {
          element.dispose();
        }

        emblemConfirmationView.hide();
        focusedObject.value = null;
        heartTriesState.refresh();
        scatterAnimation.reset();

        boardController.toggleDraggingStatus(true);

        emit(SuccessState(state.copyWith(boardObjects: [], placedObjects: [])));
      },
    );
  }

  Future<void> onRestart(BuildContext context) async {
    _isGameOverShown = false;
    await restartLevel();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> restartLevel() async {
    _isGameOverShown = false;
    state.whenOrNull(
      success: (state) async {
        unawaited(audioCubit.resumeBgm());
        final level = state.level;

        FlutterEngine.schedulePostFrameCallback((timeStamp) async {
          resetLevelState();
          gameSeed = levelProgressService.createNextSeed(
            levelsCubit: levelsService,
            continentType: params.continentType,
            level: level,
          );

          final parts = await generateBoardParts(level, state.difficult);

          emit(
            SuccessState(
              state.copyWith(
                placedObjects: [],
                boardObjects: [...prepareShowcaseObjects(parts, level)],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void onObjectFocusAdded(Object object) {
    // FlutterEngine.widgetPostFrameCallback((timeStamp) {
    //   boardController.toggleDraggingStatus(false);
    // });
  }

  @override
  void onObjectFocusRemoved(Object object) {
    emblemConfirmationView.hide();

    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      boardController.toggleDraggingStatus(true);
    });
  }

  void tryPlaceFocussedEmblem() {
    state.whenOrNull(
      success: (state) {
        final sceneObject = focusedObject.value as EmblemSceneObjectState?;
        final focussedObject = sceneObject?.widget.gameObject;

        if (focussedObject != null) {
          final object = focussedObject.toEmblemPart();

          object.position = sceneObject!.gameObject.position;
          object.rotation = sceneObject.gameObject.rotation;
          object.scale = sceneObject.scaleConverter(
            sceneObject.gameObject.scale,
          );

          final flagObject = state.level.flag.objects
              .whereType<EmblemPart>()
              .firstWhereOrNull((e) => e.uniqueName == object.uniqueName);

          if (flagObject == null) {
            onIncorrectPlacing();
            return;
          }

          final fitValue = state.flagFitValue;

          if (placementService.isFocusedEmblemPlacementValid(
            candidate: object,
            target: flagObject,
            fitValue: fitValue,
          )) {
            final placedObjects = [
              ...state.placedObjects.where((e) => e is! DraggableEmblemPart),
              flagObject,
            ];

            _applyPlacement(state, flagObject, placedObjects: placedObjects);
          } else {
            onIncorrectPlacing();
          }
        }
      },
    );
  }

  void tryRemoveFocussedEmblem() {
    state.whenOrNull(
      success: (state) {
        final focussedObject = focusedObject.value;
        logger.d(
          focussedObject != null && focussedObject is GameObjectWidgetState,
        );

        if (focussedObject != null && focussedObject is GameObjectWidgetState) {
          final widget = focussedObject;

          final placedObjects = [...state.placedObjects];
          state.boardObjects
              .firstWhere(
                (e) => e.object.uniqueName == widget.gameObject.uniqueName,
              )
              .setActive(true);

          placedObjects.removeWhere(
            (e) => e.uniqueName == widget.gameObject.uniqueName,
          );

          emit(SuccessState(state.copyWith(placedObjects: placedObjects)));

          onObjectFocusRemoved(focussedObject);
          focusedObject.value = null;
        }
      },
    );
  }

  Future<void> openMenu(BuildContext context) async {
    if (_isGameOverShown || isClosed || !context.mounted) {
      return;
    }

    showcase.dismiss();
    await onMenuOpened();

    if (!context.mounted) return;

    await PuzzleMenuDialog(
      onRestart: onRestart,
      onExit: onGameExit,
      seed: gameSeed,
    ).showModal(context);

    await onMenuClosed();
  }

  void onGameExit(BuildContext context) async {
     Navigator.of(context).pop();
     await this.context.maybePop();
  }

  Future<void> onMenuOpened() async {}

  Future<void> onMenuClosed() async {}

  void skipLevel() {
    state.whenOrNull(
      success: (state) {
        onLevelCompleted(state);
      },
    );
  }

  double getScoreMultiplier(GameDifficult difficult) => switch (difficult) {
    GameDifficult.superEasy => 1,
    GameDifficult.easy => 1.5,
    GameDifficult.medium => 2,
    GameDifficult.hard => 2.5,
    GameDifficult.extraHard => 3,
  };

  Future<List<BoardItem<ProcessGameObject>>> generateBoardParts(
    GameLevel level,
    GameDifficult difficult,
  ) async {
    return state.maybeWhen(
      success: (state) {
        final levels = FactoryGameContinent.allLevels;

        final generator = switch (difficult) {
          GameDifficult.superEasy => PuzzleSuperEasyGenerator.new,
          GameDifficult.easy => PuzzleEasyGenerator.new,
          GameDifficult.medium => PuzzleMediumGenerator.new,
          GameDifficult.hard => PuzzleHardGenerator.new,
          GameDifficult.extraHard => PuzzleExtraHardGenerator.new,
        };

        final generatedObjects = generator(
          levels: levels,
        ).generate(level.flag, Random(gameSeed));

        final List<BoardItem<ProcessGameObject>> parts = [
          ...generatedObjects.map((e) => BoardItem(object: e)),
        ];

        return parts;
      },
      orElse: () => [],
    );
  }

  List<BoardItem<ProcessGameObject>> prepareShowcaseObjects(
    List<BoardItem<ProcessGameObject>> parts,
    GameLevel level,
  ) {
    final preparedParts = [...parts];

    if (this is! PuzzleFastModeCubit) {
      if (!showcase.isCompleted("puzzle_common_object")) {
        final flagPartIndex = preparedParts.indexWhere(
          (e) => level.flag.objects.whereType<PathGameObject>().any(
            (element) => e.object.uniqueName == element.uniqueName,
          ),
        );

        if (flagPartIndex != -1) {
          final object = preparedParts[flagPartIndex];
          preparedParts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleCommonObjectShowcase(
              showcaseKey: showcase.showcaseCommonObject,
              flagExposer: flagExposer,
              onReady: () {
                showcase.show([
                  showcase.showcaseCommonObject,
                ], "puzzle_common_object");
              },
              child: instance,
            ),
          );
        }
      }
      logger.f(showcase.isCompleted("puzzle_emblem_object"));
      if (!showcase.isCompleted("puzzle_emblem_object")) {
        final flagPartIndex = preparedParts.indexWhere(
          (e) => level.flag.objects.whereType<EmblemPart>().any(
            (element) => e.object.uniqueName == element.uniqueName,
          ),
        );

        if (flagPartIndex != -1) {
          final object = preparedParts[flagPartIndex];

          preparedParts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleEmblemObjectStep1Showcase(
              showcaseKey: showcase.emblemObjectStep1,
              flagExposer: flagExposer,
              onReady: () {
                showcase.show([
                  showcase.emblemObjectStep1,
                ], "puzzle_emblem_object");
                showcase.complete("puzzle_emblem_object");
              },
              child: instance,
            ),
          );
        }
      }

      if (!showcase.isCompleted("puzzle_colored_object")) {
        final flagPartIndex = preparedParts.indexWhere(
          (e) => e.object is ColoredPart,
        );

        if (flagPartIndex != -1) {
          final object = preparedParts[flagPartIndex];

          preparedParts[flagPartIndex] = BoardItem(
            object: object.object,
            build: (instance) => PuzzleColoredObjectStep1Showcase(
              showcaseKey: showcase.coloredObjectStep1,
              onTap: () {
                showcase.complete("puzzle_colored_object");
              },
              onReady: () {
                showcase.show([
                  showcase.coloredObjectStep1,
                ], "puzzle_colored_object");
              },
              child: instance,
            ),
          );
        }
      }
    }

    return preparedParts;
  }
}
