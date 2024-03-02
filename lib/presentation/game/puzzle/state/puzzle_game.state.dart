import 'package:armar/armar.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';

import '../../../../domain/entities/game/game_levels/game_level.dart';

class PuzzleGameState {
  final RxValue<GameLevel> level;
  final RxValue<GameDifficult> difficult;
  final RxList<BoardItem> boardObjects;

  final RxList<ProcessGameObject> placedObjects;

  double flagFitValue;

  PuzzleGameState({
    required List<BoardItem> boardObjects,
    required GameDifficult difficult,
    required GameLevel level,
    required this.flagFitValue,
  })  : level = RxValue(level),
        difficult = RxValue(difficult),
        boardObjects = RxList(boardObjects),
        placedObjects = RxList();
}
