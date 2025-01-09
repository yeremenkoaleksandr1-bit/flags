import 'package:equatable/equatable.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';

class PuzzleGameState extends Equatable {
  final GameLevel level;
  final GameDifficult difficult;
  final List<BoardItem> boardObjects;

  GameFlag get flag => level.flag;

  final List<ProcessGameObject> placedObjects;

  final double flagFitValue;

  const PuzzleGameState({
    required this.level,
    required this.difficult,
    required this.boardObjects,
    required this.placedObjects,
    required this.flagFitValue,
  });

  PuzzleGameState copyWith({
    GameLevel? level,
    GameDifficult? difficult,
    List<BoardItem>? boardObjects,
    List<ProcessGameObject>? placedObjects,
    double? flagFitValue,
  }) {
    return PuzzleGameState(
      level: level ?? this.level,
      difficult: difficult ?? this.difficult,
      boardObjects: boardObjects ?? this.boardObjects,
      placedObjects: placedObjects ?? this.placedObjects,
      flagFitValue: flagFitValue ?? this.flagFitValue,
    );
  }

  void disposeState() {
    level.dispose();

    for (final e in boardObjects) {
      e.dispose();
    }

    for (final e in placedObjects) {
      e.dispose();
    }
  }

  @override
  List<Object?> get props => [
        level,
        difficult,
        boardObjects,
        placedObjects,
        flagFitValue,
      ];
}

class PuzzleFastModeState extends PuzzleGameState {
  final int timerRx;

  const PuzzleFastModeState({
    required this.timerRx,
    required super.boardObjects,
    required super.difficult,
    required super.level,
    required super.flagFitValue,
    required super.placedObjects,
  });

  @override
  PuzzleFastModeState copyWith({
    int? timerRx,
    GameLevel? level,
    GameDifficult? difficult,
    List<BoardItem>? boardObjects,
    List<ProcessGameObject>? placedObjects,
    double? flagFitValue,
  }) {
    return PuzzleFastModeState(
      timerRx: timerRx ?? this.timerRx,
      boardObjects: boardObjects ?? this.boardObjects,
      difficult: difficult ?? this.difficult,
      level: level ?? this.level,
      flagFitValue: flagFitValue ?? this.flagFitValue,
      placedObjects: placedObjects ?? this.placedObjects,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        timerRx,
      ];
}
