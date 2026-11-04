// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/core/extensions/context.dart';
import 'package:flags/core/extensions/num.dart';
import 'package:flags/core/features/features.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/lose.dialog.dart';
import 'package:flags/features/games/presentation/puzzle/overlays/start_game.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/game/puzzle/onboarding/showcase_fastmode.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class PuzzleFastModeCubit extends PuzzleCommonModeCubit {
  PuzzleFastModeCubit(
    super.context,
    super.vsync, {
    required super.params,
    required super.appCubit,
    required super.levelsCubit,
    required super.onboardingService,
  });

  late final PuzzleGameFastModeShowcase showcaseFm = PuzzleGameFastModeShowcase(
    service: onboardingService,
  );



  late final PeriodicTimer periodicTimer = PeriodicTimer();

  late final ValueNotifier<int> timerRx = ValueNotifier(
    getInitialTime(params.difficult),
  );

  late int initialTime = timerRx.value;

  late final ValueNotifier<int> preparingTimer = ValueNotifier(-1);
  final Completer prepareGameCompleter = Completer();
  StreamSubscription<int>? _timerSubscription;
  StreamSubscription<int>? _prepareSubscription;
  bool _isPreparationCountdownStarted = false;
  bool _isExitingFastMode = false;
  bool _isFastModeGameOverShown = false;

  int get initialTimerValue => timerRx.value;

  ValueNotifier<int> get timerStream => timerRx;

  Future<void> _stopFastModeActivity() async {
    _isPreparationCountdownStarted = false;
    await _timerSubscription?.cancel();
    await _prepareSubscription?.cancel();
    _timerSubscription = null;
    _prepareSubscription = null;
    periodicTimer.pause();
  }

  @override
  Future<void> onInit() {
    gamePreferences.resetStreak();
    return super.onInit();
  }

  @override
  Future<void> preInitialization() async {
    gameSeed = Random().nextInt(int32MaxValue);

    flagExposer.renderBox.addListener(onFlagBuilt);

    FlutterEngine.widgetPostFrameCallback((timeStamp) async {
      if (!showcaseFm.isCompleted("fast_mode")) {
        showcaseFm.show([showcaseFm.step1, showcaseFm.step2], "fast_mode");

        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        timerRx.notifyListeners();
      } else {
        await startPreparationCountdown();
      }
    });
  }

  Future<void> startPreparationCountdown() async {
    if (_isPreparationCountdownStarted) {
      return;
    }

    _isPreparationCountdownStarted = true;
    await PreparingFastModeInitializationGame(
      preparingTimer: preparingTimer,
      onReady: (context) async {
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        timerRx.notifyListeners();
        preparingTimer.value = 3;
        await Future.delayed(const Duration(milliseconds: 250), () {
          _prepareSubscription?.cancel();
          _prepareSubscription = periodicTimer.start(3).listen((event) {
            if (isClosed) {
              return;
            }

            preparingTimer.value = event;

            if (event <= 0) {
              _isPreparationCountdownStarted = false;
              initializeInGameTimer();
              Navigator.of(context).pop();
            }
          });
        });
      },
    ).showDialog(context);
  }

  Future<void> initializeInGameTimer() async {
    await _timerSubscription?.cancel();
    _timerSubscription = periodicTimer.start(initialTime).listen((event) async {
      if (isClosed) {
        return;
      }

      timerRx.value = event;

      if (event <= 0) {
        unawaited(audioCubit.playSfx(GameSfx.timerEnd));
        await onGameOver();
      } else if (event <= 3) {
        if (event % 2 == 1) {
          unawaited(audioCubit.playSfx(GameSfx.timerTick1));
        } else {
          unawaited(audioCubit.playSfx(GameSfx.timerTick2));
        }
      }
    });
  }

  void completeFastModeShowcase() {
    showcaseFm.dismiss();
    unawaited(startPreparationCountdown());
  }

  void timerTick(int value) {
    timerRx.value = value;
  }

  void onTimerCompleted() {
    onGameOver();
  }

  late Completer<dynamic> _fastModeGenerationCompleter;

  Future<void> initializeFastMode(GameDifficult difficult) async {
    state.whenOrNull(
      success: (state) {
        _fastModeGenerationCompleter = Completer();

        FlutterEngine.schedulePostFrameCallback((timeStamp) async {


          final randomLevel = FactoryGameContinent.allLevels.random();

          resetLevelState();

          final parts = await generateBoardParts(randomLevel, difficult);

          emit(
            SuccessState(
              state.copyWith(
                difficult: difficult,
                level: randomLevel,
                boardObjects: [...parts],
                placedObjects: [],
              ),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 100));

          _fastModeGenerationCompleter.complete();
        });
      },
    );

    return await _fastModeGenerationCompleter.future;
  }

  @override
  Future<void> onClose() async {
    showcaseFm.dismiss();
    await _stopFastModeActivity();
    periodicTimer.dispose();
    flagExposer.renderBox.removeListener(onFlagBuilt);
    audioCubit.playBgm(GameMusics.continents);
    super.onClose();
  }

  @override
  Future<void> onLevelCompleted(PuzzleGameState state) async {
    if (_isExitingFastMode) {
      return;
    }

    _isFastModeGameOverShown = false;
    _isPreparationCountdownStarted = false;
    periodicTimer.pause();
    gamePreferences.recordWin();
    await monetizationCubit.onFastModeRoundCompleted();

    await prepareFastModeLevel();
  }

  Future<void> prepareFastModeLevel([bool isRestart = false]) async {
    final GlobalKey moneyKey = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.whenOrNull(
        success: (state) async {
          final Completer moneyAddCompleter = Completer();

          await PreparingFastModeInitializationGame(
            preparingTimer: preparingTimer,
            onReady: (context) async {
              // add money

              if (!isRestart) {
                final uiMoneyLayer = UiMoneyLayer.find();
                uiMoneyLayer.setDisplayConfig(null);
                bool isCloseMoney = false;
                preparingTimer.value = -1;
                await uiMoneyLayer.show();

                final moneys = calcWinnerMoney(state.difficult);

                late OverlayEntry entry;

                entry = OverlayEntry(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () async {
                        if (!moneyAddCompleter.isCompleted) {
                          await uiMoneyLayer.hide();
                          entry.remove();
                          isCloseMoney = true;
                          moneyAddCompleter.complete();
                        }
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 52,
                                child: UIMoney(key: moneyKey),
                              ),
                              Gap.h12,
                              FText("+$moneys"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                Overlay.of(context).insert(entry);

                gamePreferences.addMoney(calcWinnerMoney(state.difficult));

                await Future.delayed(const Duration(milliseconds: 250));

                if (!isCloseMoney) {
                  final context = moneyKey.currentContext;
                  if (context != null) {
                    final rect = context.renderBox!.rect;

                    uiMoneyLayer
                        .addMoneys(() => rect.center, moneys.clamp(1, 25))
                        .then((value) async {
                          await uiMoneyLayer.hide();
                          entry.remove();
                          isCloseMoney = true;

                          if (!moneyAddCompleter.isCompleted) {
                            moneyAddCompleter.complete();
                          }
                        });
                  }
                }
              } else {
                moneyAddCompleter.complete();
              }

              await moneyAddCompleter.future;

              final initialTime = getInitialTime(
                [...GameDifficult.values].random(),
              );
              timerRx.value = initialTime;
              this.initialTime = initialTime;

              preparingTimer.value = 3;

              await initializeFastMode([...GameDifficult.values].random());

              await _prepareSubscription?.cancel();
              _prepareSubscription = periodicTimer.start(3).listen((event) {
                if (isClosed) {
                  return;
                }

                preparingTimer.value = event;

                if (event == 0) {
                  Navigator.of(context).pop();

                  initializeInGameTimer();
                }
              });
            },
          ).showDialog(context);
        },
      );
    });
  }

  @override
  Future<void> onGameOver() async {
    if (_isExitingFastMode || _isFastModeGameOverShown) {
      return;
    }

    _isFastModeGameOverShown = true;
    showcaseFm.dismiss();
    await _stopFastModeActivity();
    gamePreferences.resetStreak();

    if (isClosed || !context.mounted) {
      return;
    }

    unawaited(() async {
      await audioCubit.playSfx(GameSfx.gameLoose);
      await audioCubit.pauseBgm();
    }());

    // детали разлетаются с флага, затем реклама/окно проигрыша
    if (kPuzzleScatterEnabled) {
      await scatterAnimation.forward(from: 0);
      if (isClosed || !context.mounted) {
        return;
      }
    }

    await monetizationCubit.onFastModeRoundCompleted();

    if (isClosed || !context.mounted) {
      return;
    }

    await _showFastModeLoseDialog();
    // окно закрыто — новые детали на следующем флаге рисуются как обычно
    if (!isClosed) scatterAnimation.reset();
  }

  Future<void> _showFastModeLoseDialog() async {
    await _waitUntilAppResumed();

    if (isClosed || !context.mounted) {
      return;
    }

    await WidgetsBinding.instance.endOfFrame;
    await Future.delayed(const Duration(milliseconds: 100));

    if (isClosed || !context.mounted) {
      return;
    }

    await PuzzleLoseDialog(
      onRestart: onRestart,
      onExit: onGameExit,
    ).showModal(context, barrierDismissible: false, useRootNavigator: true);
  }

  Future<void> _waitUntilAppResumed() async {
    final binding = WidgetsBinding.instance;
    final deadline = DateTime.now().add(const Duration(seconds: 3));

    while (!isClosed && DateTime.now().isBefore(deadline)) {
      final lifecycleState = binding.lifecycleState;
      if (lifecycleState == null ||
          lifecycleState == AppLifecycleState.resumed) {
        return;
      }

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Future<void> onGameExit(BuildContext context) async {
    _isExitingFastMode = true;
    _isFastModeGameOverShown = false;
    showcaseFm.dismiss();
    await _stopFastModeActivity();
    gamePreferences.resetStreak();
    await context.maybePop();
    await this.context.maybePop();

    //super.onGameExit(context);
  }

  @override
  Future<void> onRestart(BuildContext context) async {
    _isExitingFastMode = false;
    _isFastModeGameOverShown = false;
    gamePreferences.resetStreak();
    _isPreparationCountdownStarted = false;
    await super.onRestart(context);

    await prepareFastModeLevel(true);
  }

  @override
  Future<void> onMenuOpened() async {
    showcaseFm.dismiss();
    periodicTimer.pause();
  }

  @override
  Future<void> onMenuClosed() async {
    if (_isExitingFastMode || isClosed) {
      return;
    }

    periodicTimer.resumePause();
  }

  int getInitialTime(GameDifficult difficult) {
    return 10 * (getScoreMultiplier(difficult) + 1).round();
  }

  int calcWinnerMoney(GameDifficult difficult) {
    num money = 50 * (getScoreMultiplier(difficult) + 1);

    final spendTime = initialTime - timerRx.value;

    if (spendTime != 0) {
      money = money ~/ spendTime;
    }

    return money.toInt();
  }
}
