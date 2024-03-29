// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:armar/armar.dart';
import 'package:flags/core/extensions/num.dart';
import 'package:flags/core/features/features.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/puzzle/overlays/start_game.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract interface class IPuzzleFastModePresenter
    implements IPuzzleCommonModePresenter {
  Stream<int> get timerStream;

  int get initialTimerValue;
}

class PuzzleFastModePresenterImpl extends PuzzleCommonModePresenterImpl
    implements IPuzzleFastModePresenter {
  PuzzleFastModePresenterImpl(super.context, {required super.params});

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
  Stream<int> get timerStream => timerRx.stream;

  @override
  Future<void> preInitialization() async {
    FlutterEngine.schedulePostFrameCallback((timeStamp) async {
      await PreparingFastModeInitializationGame(
        preparingTimer: preparingTimer.stream,
        onReady: () async {
          timerRx.notify();
          preparingTimer.value = 3;
          await Future.delayed(const Duration(milliseconds: 250), () {
            periodicTimer.start(3).listen(
              (event) {
                preparingTimer.value = event;

                if (event <= 0) {
                  periodicTimer.start(timerRx.value).listen((event) {
                    timerRx.value = event;

                    if (event <= 0) {
                      onGameOver();
                    }
                  });
                  QR.back();
                }
              },
            );
          });
        },
      ).showDialog(context);

      // initializeFastMode(params.difficult);

      gameSeed = Random().nextInt(int32MaxValue);

      flagExposer.renderBox.stream.listen(onFlagBuilt);
    });
  }

  void timerTick(int value) {
    timerRx.value = value;
  }

  void onTimerCompleted() {
    onGameOver();
  }

  late Completer _fastModeGenerationCompleter;

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

  Future<void> prepareFastModeLevel() async {
    await PreparingFastModeInitializationGame(
      preparingTimer: preparingTimer.stream,
      onReady: () async {
        // add money
        final uiMoneyLayer = UiMoneyLayer.find();

        await uiMoneyLayer.show();

        final moneys = calcWinnerMoney(state.difficult.value);

        final initialTime = getInitialTime([...GameDifficult.values].random);
        timerRx.value = initialTime;
        this.initialTime = initialTime;

        preparingTimer.value = -1;

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        IAppPresenter.I.gameState.addMoney(
          calcWinnerMoney(state.difficult.value),
        );

        await uiMoneyLayer.addMoneys(const Offset(-20, 100), 5);
        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
        await uiMoneyLayer.hide();

        preparingTimer.value = 3;

        await initializeFastMode([...GameDifficult.values].random);

        periodicTimer.start(3).listen((event) {
          preparingTimer.value = event;

          if (event == 0) {
            QR.back();

            periodicTimer.start(initialTime).listen((event) {
              timerRx.value = event;

              if (event <= 0) {
                onGameOver();
              }
            });
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
    await prepareFastModeLevel();
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
