import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_manager/state_manager.dart';

class PuzzleGameState implements IDisposable {
  final ValueNotifier<GameLevel> level;
  final ValueNotifier<GameDifficult> difficult;
  final ValueNotifierList<BoardItem> boardObjects;

  GameFlag get flag => level.value.flag;

  final ValueNotifierList<ProcessGameObject> placedObjects;

  double flagFitValue;

  PuzzleGameState({
    required List<BoardItem> boardObjects,
    required GameDifficult difficult,
    required GameLevel level,
    required this.flagFitValue,
  })  : level = ValueNotifier(level),
        difficult = ValueNotifier(difficult),
        boardObjects = ValueNotifierList(boardObjects),
        placedObjects = ValueNotifierList();

  @override
  void dispose() {
    level.dispose();
    difficult.dispose();
    boardObjects.dispose();
    placedObjects.dispose();
  }
}

class PuzzleFastModeState extends PuzzleGameState {
  final ValueNotifier<int> timerRx;

  PuzzleFastModeState({
    required this.timerRx,
    required super.boardObjects,
    required super.difficult,
    required super.level,
    required super.flagFitValue,
  });

  @override
  void dispose() {
    timerRx.dispose();
    super.dispose();
  }
}
