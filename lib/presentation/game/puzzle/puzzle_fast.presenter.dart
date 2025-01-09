// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:bloc_utils/bloc_utils.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/extensions/num.dart';
import 'package:flags/core/features/features.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/games/presentation/puzzle/overlays/start_game.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../uikit/uikit.dart';
import 'onboarding/showcase_fastmode.dart';

abstract interface class IPuzzleFastModePresenter
    implements IPuzzleCommonModeCubit<PuzzleFastModeState> {
  PuzzleGameFastModeShowcase get showcaseFm;

  ValueListenable<int> get timerStream;

  int get initialTimerValue;
}

class PuzzleFastModePresenterImpl
    extends PuzzleCommonModePresenterImpl<PuzzleFastModeState>
    implements IPuzzleFastModePresenter {
  PuzzleFastModePresenterImpl(
    super.context,
    super.vsync, {
    required super.params,
    required super.appCubit,
    required super.levelsCubit,
  });

  @override
  final PuzzleGameFastModeShowcase showcaseFm = PuzzleGameFastModeShowcase();

  WinStreak get winStreak => gamePreferences.state.winStreak;

  late ContinentType _randomContinent = params.continentType;

  late final PeriodicTimer periodicTimer = PeriodicTimer();

  late final ValueNotifier<int> timerRx =
      ValueNotifier(getInitialTime(params.difficult));

  late int initialTime = timerRx.value;

  late final ValueNotifier<int> preparingTimer = ValueNotifier(-1);
  final Completer prepareGameCompleter = Completer();

  @override
  int get initialTimerValue => timerRx.value;

  @override
  ValueNotifier<int> get timerStream => timerRx;

  @override
  Future<void> onInit() {
    winStreak.resetStreak();
    return super.onInit();
  }

  @override
  Future<void> preInitialization() async {
    gameSeed = Random().nextInt(int32MaxValue);

    flagExposer.renderBox.addListener(onFlagBuilt);

    FlutterEngine.widgetPostFrameCallback((timeStamp) async {
      if (!showcaseFm.isCompleted("fast_mode")) {
        showcaseFm.completeFuture = Completer();

        showcaseFm.show(
          [
            showcaseFm.step1,
            showcaseFm.step2,
          ],
          "fast_mode",
        );

        timerRx.notifyListeners();

        await showcaseFm.completeFuture?.future;

        initializeInGameTimer();
      } else {
        await PreparingFastModeInitializationGame(
          preparingTimer: preparingTimer,
          onReady: () async {
            timerRx.notifyListeners();
            preparingTimer.value = 3;
            await Future.delayed(const Duration(milliseconds: 250), () {
              periodicTimer.start(3).listen(
                (event) {
                  preparingTimer.value = event;

                  if (event <= 0) {
                    initializeInGameTimer();
                    Navigator.of(context).pop();
                  }
                },
              );
            });
          },
        ).showDialog(context);
      }
    });
  }

  Future<void> initializeInGameTimer() async {
    periodicTimer.start(initialTime).listen((event) async {
      timerRx.value = event;

      if (event <= 0) {
        await audioCubit.playSfx(GameSfx.timerEnd);
        onGameOver();
      } else if (event <= 3) {
        if (event % 1 == 1) {
          audioCubit.playSfx(GameSfx.timerTick1);
        } else {
          audioCubit.playSfx(GameSfx.timerTick2);
        }
      }
    });
  }

  void timerTick(int value) {
    timerRx.value = value;
  }

  void onTimerCompleted() {
    onGameOver();
  }

  late Completer<dynamic> _fastModeGenerationCompleter;

  Future<void> initializeFastMode(GameDifficult difficult) async {
    state.whenOrNull(success: (state) {
      _fastModeGenerationCompleter = Completer();

      FlutterEngine.schedulePostFrameCallback((timeStamp) async {
        _randomContinent = [...ContinentType.values].random();

        final randomLevel = FactoryGameContinent.allLevels.random();

        resetLevelState();

        final parts = await generateBoardParts(randomLevel, difficult);

        emit(
          SuccessState(
            state.copyWith(
              difficult: difficult,
              level: randomLevel,
              boardObjects: [...parts],
            ),
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        _fastModeGenerationCompleter.complete();
      });
    });

    return await _fastModeGenerationCompleter.future;
  }

  @override
  Future<void> onClose() async {
    periodicTimer.pause();
    periodicTimer.dispose();
    flagExposer.renderBox.removeListener(onFlagBuilt);
    super.onClose();
  }

  @override
  Future<void> onLevelCompleted(PuzzleGameState state) async {
    periodicTimer.pause();
    winStreak.recordWin();

    await prepareFastModeLevel();
  }

  Future<void> prepareFastModeLevel([bool isRestart = false]) async {
    state.whenOrNull(
      success: (state) async {
        final Completer moneyAddCompleter = Completer();

        await PreparingFastModeInitializationGame(
          preparingTimer: preparingTimer,
          onReady: () async {
            // add money

            if (!isRestart) {
              final uiMoneyLayer = UiMoneyLayer.find();
              bool isCloseMoney = false;
              preparingTimer.value = -1;
              await uiMoneyLayer.show();

              final GlobalKey moneyKey = GlobalKey();

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
                              child: UIMoney(
                                key: moneyKey,
                              ),
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

              // Overlay.of(QR.context!).insert(entry);

              gamePreferences.addMoney(
                calcWinnerMoney(state.difficult),
              );

              await Future.delayed(100.milliseconds);

              if (!isCloseMoney) {
                final rb =
                    moneyKey.currentContext!.findRenderObject()! as RenderBox;
                final rect = rb.rect;

                uiMoneyLayer
                    .addMoneys(
                  rect.center,
                  moneys.clamp(
                    1,
                    25,
                  ),
                )
                    .then((value) async {
                  await uiMoneyLayer.hide();
                  entry.remove();
                  isCloseMoney = true;

                  if (!moneyAddCompleter.isCompleted) {
                    moneyAddCompleter.complete();
                  }
                });
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

            await initializeFastMode(
              [...GameDifficult.values].random(),
            );

            periodicTimer.start(3).listen((event) {
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
  }

  @override
  Future<void> onGameOver() async {
    winStreak.resetStreak();
    periodicTimer.pause();
    await super.onGameOver();
  }

  @override
  void onGameExit(BuildContext context) {
    winStreak.resetStreak();
    super.onGameExit(context);
  }

  @override
  Future<void> onRestart(BuildContext context) async {
    await super.onRestart(context);

    await prepareFastModeLevel(true);
  }

  @override
  Future<void> onMenuOpened() async {
    periodicTimer.pause();
  }

  @override
  Future<void> onMenuClosed() async {
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
