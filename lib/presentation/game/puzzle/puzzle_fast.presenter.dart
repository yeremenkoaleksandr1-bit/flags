// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:armar/armar.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/extensions/num.dart';
import 'package:flags/core/features/features.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/puzzle/overlays/start_game.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../uikit/uikit.dart';
import 'onboarding/showcase_fastmode.dart';

abstract interface class IPuzzleFastModePresenter
    implements IPuzzleCommonModePresenter {
  PuzzleGameFastModeShowcase get showcaseFm;

  RxValue<int> get timerStream;

  int get initialTimerValue;
}

class PuzzleFastModePresenterImpl extends PuzzleCommonModePresenterImpl
    implements IPuzzleFastModePresenter {
  PuzzleFastModePresenterImpl(super.context, {required super.params});

  @override
  final PuzzleGameFastModeShowcase showcaseFm = PuzzleGameFastModeShowcase();

  WinStreak get winStreak => IAppPresenter.I.gameState.data.winStreak;

  late ContinentType _randomContinent = params.continentType;

  @override
  List<GameLevel> get levels =>
      FactoryGameContinent().create(_randomContinent).levels;

  late final PeriodicTimer periodicTimer = PeriodicTimer();

  late final RxValue<int> timerRx = RxValue(getInitialTime(params.difficult));

  late int initialTime = timerRx.value;

  late final RxValue<int> preparingTimer = RxValue(-1);
  final Completer prepareGameCompleter = Completer();

  @override
  int get initialTimerValue => timerRx.value;

  @override
  RxValue<int> get timerStream => timerRx;

  @override
  Future<void> preInitialization() async {
    gameSeed = Random().nextInt(int32MaxValue);

    flagExposer.renderBox.stream.listen(onFlagBuilt);

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

        timerRx.notify();

        await showcaseFm.completeFuture?.future;

        initializeInGameTimer();
      } else {
        await PreparingFastModeInitializationGame(
          preparingTimer: preparingTimer,
          onReady: () async {
            timerRx.notify();
            preparingTimer.value = 3;
            await Future.delayed(const Duration(milliseconds: 250), () {
              periodicTimer.start(3).listen(
                (event) {
                  preparingTimer.value = event;

                  if (event <= 0) {
                    initializeInGameTimer();
                    QR.back();
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
        await audioController.playSfx(GameSfx.timerEnd);
        onGameOver();
      } else if (event <= 3) {
        if (event % 1 == 1) {
          audioController.playSfx(GameSfx.timerTick1);
        } else {
          audioController.playSfx(GameSfx.timerTick2);
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
    _fastModeGenerationCompleter = Completer();

    FlutterEngine.schedulePostFrameCallback((timeStamp) async {
      _randomContinent = [...ContinentType.values].random;

      final randomLevel = levels.random;

      resetLevelState();

      state.difficult.value = difficult;
      state.level.value = randomLevel;

      final parts = await generateBoardParts();
      state.boardObjects.run(() {
        state.boardObjects.clear();
        state.boardObjects.addAll(parts);
      });

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      _fastModeGenerationCompleter.complete();
    });
    return await _fastModeGenerationCompleter.future;
  }

  @override
  void onClose() {
    periodicTimer.pause();
    periodicTimer.dispose();
    super.onClose();
  }

  @override
  Future<void> onLevelCompleted() async {
    periodicTimer.pause();
    winStreak.recordWin();

    await prepareFastModeLevel();
  }

  Future<void> prepareFastModeLevel([bool isRestart = false]) async {
    await PreparingFastModeInitializationGame(
      preparingTimer: preparingTimer,
      onReady: () async {
        // add money

        if (!isRestart) {
          final uiMoneyLayer = UiMoneyLayer.find();
          preparingTimer.value = -1;
          await uiMoneyLayer.show();

          final GlobalKey moneyKey = GlobalKey();

          final moneys = calcWinnerMoney(state.difficult.value);

          final entry = OverlayEntry(
            builder: (context) {
              return Center(
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
              );
            },
          );

          Overlay.of(QR.context!).insert(entry);

          await Future.delayed(
            const Duration(milliseconds: 500),
          );

          IAppPresenter.I.gameState.addMoney(
            calcWinnerMoney(state.difficult.value),
          );

          final rect = moneyKey.currentContext!.renderBox!.rect;

          await uiMoneyLayer.addMoneys(
            rect.center,
            moneys.clamp(
              1,
              25,
            ),
          );
          await Future.delayed(
            const Duration(milliseconds: 1000),
          );
          await uiMoneyLayer.hide();
          entry.remove();
          await Future.delayed(
            const Duration(milliseconds: 250),
          );
        }

        final initialTime = getInitialTime([...GameDifficult.values].random);
        timerRx.value = initialTime;
        this.initialTime = initialTime;

        preparingTimer.value = 3;

        await initializeFastMode([...GameDifficult.values].random);

        periodicTimer.start(3).listen((event) {
          preparingTimer.value = event;

          if (event == 0) {
            QR.back();

            initializeInGameTimer();
          }
        });
      },
    ).showDialog(context);
  }

  @override
  Future<void> onGameOver() async {
    winStreak.resetStreak();
    periodicTimer.pause();
    await super.onGameOver();
  }

  @override
  Future<void> onRestart() async {
    await super.onRestart();
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
