// ignore_for_file: invalid_use_of_protected_member, avoid_void_async

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:collection/collection.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:flags/core/extensions/num.dart';
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
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flags/features/games/presentation/components/heart_tries/heart_tries.dart';
import 'package:flags/features/games/presentation/games_factory.page.dart';
import 'package:flags/features/games/presentation/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/complete_continent.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/lose.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/menu.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/winner.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/emblem.dart';
import 'package:flags/features/games/presentation/puzzle/views/board.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/logger.dart';
import 'package:flags/main.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
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
import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PuzzleCommonModeCubit extends StatedCubit<PuzzleGameState>
    with ProcessedObjectFocusHandler {
  final IAppCubit appCubit;

  final TickerProvider vsync;

  // SHOWCASE

  final IOnboardingService onboardingService = OnboardingServiceImpl(
    prefs: sharedPreferences,
  );

  @override
  final PuzzleGameShowcase showcase = PuzzleGameShowcase();

  // ________

  final BuildContext context;

  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  IVibrationCubit get vibrationCubit => context.read<IVibrationCubit>();

  final ILevelsPickerCubit levelsCubit;

  GameLevelsCubit get levelsService => context.read<GameLevelsCubit>();

  IEmblemsService get emblemsService => appCubit.emblemsService;

  GamePreferencesCubit get gamePreferences =>
      context.read<GamePreferencesCubit>();

  final GamesFactoryPageParams params;

  PuzzleCommonModeCubit(
    this.context,
    this.vsync, {
    required this.params,
    required this.appCubit,
    required this.levelsCubit,
  })  : emblemConfirmationView = EmblemConfirmationWidgetState(),
        boardController = PartsBoardState(),
        heartTriesState = HeartTriesState(
          tries: 3,
        );

  int gameSeed = -1;

  late final AnimationController shakeAnimation = AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 100),
  );

  HeartTriesState heartTriesState;

  final IEmblemConfirmationController emblemConfirmationView;

  final PartsBoardState boardController;

  RenderBoxExposer flagExposer = RenderBoxExposer();

  @override
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
    super.onInit();

    await initialization();
  }

  Future<void> preInitialization() async {
    final savedLevel = levelsService.getLevelData(
      params.continentType,
      params.level.id,
    );

    if (savedLevel == null) {
      final seed = Random().nextInt(int32MaxValue);

      levelsService.saveLevel(
        id: params.level.id,
        data: LevelProcessData(
          completed: params.level.completed,
          seed: seed,
        ),
        continent: params.continentType,
      );

      gameSeed = seed;
    } else {
      if (savedLevel.seed == -1) {
        final seed = Random().nextInt(int32MaxValue);

        levelsService.saveLevel(
          id: params.level.id,
          data: LevelProcessData(
            completed: params.level.completed,
            seed: seed,
          ),
          continent: params.continentType,
        );

        gameSeed = seed;
      } else {
        gameSeed = savedLevel.seed;
      }
    }

    //gameSeed = 946879961;
    flagExposer.renderBox.addListener(onFlagBuilt);
  }

  @override
  Future<void> close() async {
    shakeAnimation.dispose();

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
              boardObjects: [
                ...prepareShowcaseObjects(
                  parts,
                  level,
                ),
              ],
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

        emit(
          SuccessState(
            state.copyWith(
              flagFitValue: renderBox.size.width / state.level.flag.size.x,
            ) ,
          ),
        );
      },
    );
  }

  Future<void> placeObject(ProcessGameObject object) async {
    state.whenOrNull(
      success: (state) {
        var sceneObject = state.boardObjects.firstWhereOrNull((e) {
          return e.object.key == object.key;
        });

        if (object is EmblemPart) {
          sceneObject = state.boardObjects.firstWhereOrNull((e) {
            return e.object.uniqueName == object.uniqueName;
          });
        }

        sceneObject?.setActive(false);

        emit(
          SuccessState(
            state.copyWith(
              placedObjects: [...state.placedObjects, object],
            ),
          ),
        );

        unfocusObject();
        tryCompleteLevel();

        audioCubit.playSfx(GameSfx.correctlyObjectPlacing);
      },
    );
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
    levelsService.saveLevel(
      continent: params.continentType,
      id: state.level.id,
      data: const LevelProcessData(
        completed: true,
        seed: -1,
      ),
    );

    final NextLevelData data = levelsCubit.getNextLevelFromCurrent(state.level);

    final level = state.level.copyWith();

    final emblems = [...level.flag.emblems]..removeWhere(
        (e) => emblemsService.isOpened(e.name),
      );

    final isLastLevelInSection = data.section?.difficulty != state.difficult;

    if (data.section != null) {
      PuzzleWinnerDialog(
        level: level,
        nextLevel: data.level,
        isLastLevelInSection: isLastLevelInSection,
        onExitPressed: (context) async {
          Navigator.of(context).pop();

          this.context.navigateNamedTo(
                LevelsPickerRoute.name,
              );
        },
        onNextLevelPressed: (context) async {
          Navigator.of(context).pop();
          await EasyLoading.show();

          await openNextLevel(data);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await EasyLoading.dismiss();
          });
        },
        emblems: emblems,
      ).showModal(
        context,
        barrierDismissible: false,
      );
    }

    state.level.completeLevel();

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
        onExit: (context) {
          Navigator.of(context).pop();

          this.context.navigateNamedTo(
                LevelsPickerRoute.name,
              );
        },
      ).showModal(
        context,
        barrierDismissible: false,
      );
    }
  }

  Future<void> openNextLevel(NextLevelData data) async {
    state.whenOrNull(
      success: (state) async {
        gameSeed = Random().nextInt(int32MaxValue);
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
              boardObjects: [
                ...prepareShowcaseObjects(
                  parts,
                  level,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool handleGameObject(Vector2 position, ProcessGameObject object) {
    return state.maybeWhen(
      success: (state) {
        ProcessGameObject gameObject = object;

        if (gameObject is ScalableEmblemPart) {
          final emblemFromFlag = state.flag.emblems.firstOrNull;

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

          emit(
            SuccessState(
              state.copyWith(
                placedObjects: [
                  ...state.placedObjects,
                  gameObject,
                ],
              ),
            ),
          );
          final object = state.boardObjects.firstWhere((e) {
            return e.object.uniqueName == gameObject.uniqueName;
          });

          object.setActive(false);

          return true;
        }

        final availableObject = PuzzleObjectPlacingHandler().handle(
          object: gameObject,
          flag: state.level.flag,
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
      },
      orElse: () => false,
    );
  }

  Future<void> onIncorrectPlacing() async {
    await audioCubit.playSfx(GameSfx.incorrectObjectPlacing);
    vibrationCubit.vibrate();
    shakeAnimation.forward(from: 0);

    heartTriesState.removeOneHeart();

    if (heartTriesState.isOver()) {
      onGameOver();
    }
  }

  Future<void> onGameOver() async {
    await audioCubit.playSfx(GameSfx.gameLoose);
    await audioCubit.pauseBgm();
    await PuzzleLoseDialog(
      onRestart: onRestart,
      onExit: onGameExit,
    ).showModal(
      context,
      barrierDismissible: false,
    );
  }

  void resetLevelState() {
    state.whenOrNull(success: (state) {
      for (final element in state.boardObjects) {
        element.dispose();
      }

      emblemConfirmationView.hide();
      focusedObject.value = null;
      heartTriesState.refresh();

      boardController.toggleDraggingStatus(true);

      emit(
        SuccessState(
          state.copyWith(
            boardObjects: [],
            placedObjects: [],
          ),
        ),
      );
    });
  }

  Future<void> onRestart(BuildContext context) async {
    await restartLevel();
    Navigator.of(context).pop();
  }

  Future<void> restartLevel() async {
    state.whenOrNull(
      success: (state) async {
        await audioCubit.resumeBgm();
        final level = state.level;

        FlutterEngine.schedulePostFrameCallback((timeStamp) async {
          resetLevelState();
          final seed = Random().nextInt(int32MaxValue);

          levelsService.saveLevel(
            continent: params.continentType,
            id: level.id,
            data: LevelProcessData(
              completed: level.completed,
              seed: seed,
            ),
          );

          gameSeed = seed;

          final parts = await generateBoardParts(level, state.difficult);

          emit(
            SuccessState(
              state.copyWith(
                placedObjects: [],
                boardObjects: [
                  ...prepareShowcaseObjects(
                    parts,
                    level,
                  ),
                ],
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
          object.scale =
              sceneObject.scaleConverter(sceneObject.gameObject.scale);

          final flagObject = state.level.flag.objects.firstWhereOrNull(
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
      },
    );
  }

  void tryRemoveFocussedEmblem() {
    state.whenOrNull(
      success: (state) {
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
      },
    );
  }

  Future<void> openMenu(BuildContext context) async {
    await onMenuOpened();

    await PuzzleMenuDialog(
      onRestart: onRestart,
      onExit: onGameExit,
      seed: gameSeed,
    ).showModal(context);

    await onMenuClosed();
  }

  void onGameExit(BuildContext context) async {
    await context.maybePop();

    this.context.navigateNamedTo(LevelsPickerRoute.name);
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

        final generatedObjects = generator(levels: levels).generate(
          level.flag,
          Random(gameSeed),
        );

        final List<BoardItem<ProcessGameObject>> parts = [
          ...generatedObjects.map(
            (e) => BoardItem(object: e),
          ),
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
                logger.w("qwe");
                showcase.show(
                  [showcase.showcaseCommonObject],
                  "puzzle_common_object",
                );
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
                showcase.show(
                  [showcase.emblemObjectStep1],
                  "puzzle_emblem_object",
                );
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
                showcase.show(
                  [showcase.coloredObjectStep1],
                  "puzzle_colored_object",
                );
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
