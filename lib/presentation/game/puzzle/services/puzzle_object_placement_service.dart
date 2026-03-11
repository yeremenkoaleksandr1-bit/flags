import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/scallable_emblem.dart';
import 'package:flags/presentation/game/puzzle/validators/validator.dart';
import 'package:flame/components.dart';

final class PuzzleObjectPlacementService {
  const PuzzleObjectPlacementService();

  BoardItem<ProcessGameObject>? findSceneObject({
    required List<BoardItem<ProcessGameObject>> boardObjects,
    required ProcessGameObject object,
  }) {
    return boardObjects.firstWhereOrNull((item) {
      if (object is EmblemPart) {
        return item.object.uniqueName == object.uniqueName;
      }

      return item.object.key == object.key;
    });
  }

  ProcessGameObject? resolvePlacedObject({
    required ProcessGameObject object,
    required List<ProcessGameObject> placedObjects,
    required GameFlag flag,
    required Vector2 position,
    required double fitValue,
  }) {
    if (object is ScalableEmblemPart) {
      final emblemFromFlag = flag.emblems.firstOrNull;
      var gameObject = object;

      if (emblemFromFlag != null) {
        gameObject = gameObject.copyWith(
          key: emblemFromFlag.key,
          previousMustBePlaced: emblemFromFlag.previousMustBePlaced,
        );
      }

      final isPreviousPlaced = gameObject.previousMustBePlaced?.every(
            (name) => placedObjects.map((item) => item.uniqueName).contains(name),
          ) ??
          true;

      if (!isPreviousPlaced) {
        return null;
      }

      return DraggableEmblemPart.fromEmblem(
        gameObject.copyWith(
          key: gameObject.key,
          position: position / fitValue,
        ),
        scales: gameObject.scales,
      );
    }

    return PuzzleObjectPlacingHandler().handle(
      object: object,
      flag: flag,
      placedObjects: placedObjects,
      position: position,
      fitValue: fitValue,
    );
  }

  bool isFocusedEmblemPlacementValid({
    required EmblemPart candidate,
    required EmblemPart target,
    required double fitValue,
  }) {
    final isCorrectDistance =
        target.position.distanceTo(candidate.position) < (15 / fitValue);

    var isCorrectRotation = candidate.rotation == target.rotation;

    if (!target.emblem.identicalRotation) {
      if (target.emblem.symmetrical180) {
        final rotation180 = (target.rotation + pi) % (2 * pi);
        isCorrectRotation = isCorrectRotation || candidate.rotation == rotation180;
      }

      if (target.emblem.symmetrical90) {
        final rotationDifference = (candidate.rotation - target.rotation).abs();
        final rotationRemainder = rotationDifference % (pi / 2);

        isCorrectRotation = isCorrectRotation ||
            rotationRemainder < 1e-9 ||
            (pi / 2 - rotationRemainder) < 1e-9;
      }
    } else {
      isCorrectRotation = true;
    }

    return isCorrectDistance &&
        isCorrectRotation &&
        candidate.scale == target.scale;
  }
}
