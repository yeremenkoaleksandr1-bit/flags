// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/puzzle/overlays/start_game.dart';
import 'package:flags/uikit/layout_components/overlayment/overlayment.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../core/extensions/num.dart';
import '../../../core/features/features.dart';
import '../../../domain/entities/game/game_levels/game_level.dart';
import '../../../domain/models/game/scores/win_streak.dart';
import '../../../prefabs/levels/levels.dart';
import '../../../screens/games/puzzle/overlays/preparing_fastmode_timer.dart';

abstract interface class IPuzzleFastModePresenter
    implements IPuzzleCommonModePresenter {
  Stream<int> get timerStream;

  int get initialTimerValue;
}

class PuzzleFastModePresenterImpl extends PuzzleCommonModePresenterImpl
    implements IPuzzleFastModePresenter {
  PuzzleFastModePresenterImpl(super.context, {required super.params});

  WinStreak get winStreak => IAppPresenter.i.gamePreferences.data.winStreak;

  late ContinentType _randomContinent = params.continentType;

  @override
  List<GameLevel> get levels =>
      FactoryGameContinent().create(_randomContinent).levels;

  late final PeriodicTimer periodicTimer = PeriodicTimer(
    tickDuration: const Duration(
      milliseconds: 1000,
    ),
  );

  late final RxValue<int> timerRx = RxValue(getInitialTime(params.difficult));

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

    await EasyLoading.show();
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
        const Duration(milliseconds: 500),
      );

      FlutterEngine.widgetPostFrameCallback((timeStamp) async {
        await EasyLoading.dismiss();
        _fastModeGenerationCompleter.complete();
      });
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
  void onLevelCompleted() async {
    periodicTimer.pause();
    winStreak.recordWin();

    await prepareFastModeLevel();
  }

  Future<void> prepareFastModeLevel() async {
    await PreparingFastModeInitializationGame(
      preparingTimer: preparingTimer.stream,
      onReady: () async {
        preparingTimer.value = 3;

        await initializeFastMode([...GameDifficult.values].random);

        periodicTimer.start(3).listen((event) {
          preparingTimer.value = event;

          if (event == 0) {
            QR.back();
            final initialTime =
                getInitialTime([...GameDifficult.values].random);
            timerRx.value = initialTime;
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
  void onRestart() async {
    super.onRestart();
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
}
