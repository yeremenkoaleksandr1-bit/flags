import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flame/game.dart';

import '../../../../domain/game_objects/emblems/emblem.gameObject.dart';
import '../../../../domain/game_objects/flag/flag.dart';
import '../../../../domain/game_objects/parts/path_part.dart';
import '../entities/colored_part.game_object.dart';

class PuzzleObjectPlacingHandlerData {}

class PuzzleObjectPlacingHandler {
  final double availableDistance;

  PuzzleObjectPlacingHandler({
    this.availableDistance = 10.0,
  });

  ProcessGameObject? handle({
    required double fitValue,
    required Vector2 position,
    required ProcessGameObject object,
    required GameFlag flag,
    required List<ProcessGameObject> placedObjects,
  }) {
    final objectsFromFlag = flag.objects.where(
      (e) => e.name == object.name,
    );

    if (objectsFromFlag.isEmpty) return null;

    final isPreviousPlaced = object.previousMustBePlaced?.every(
          (e) => placedObjects.map((e) => e.name).contains(e),
        ) ??
        true;

    if (!isPreviousPlaced) return null;

    final nearestObject =
        _findNearestObject(position / fitValue, objectsFromFlag);

    if (object is EmblemPart) {
      return object.copyWith(position: position / fitValue);
    }

    if (object is ColoredPart && nearestObject is PathPart) {
      if (object.color != nearestObject.color) {
        return null;
      }
    }

    final fittedFlagObjectPosition = nearestObject.position * fitValue;

    if (fittedFlagObjectPosition.distanceTo(position) < availableDistance) {
      final key = object.uniqueName == nearestObject.uniqueName
          ? nearestObject.uniqueName
          : object.uniqueName;

      if (placedObjects.any(
        (e) =>
            e.position == nearestObject.position &&
            e.name == nearestObject.name,
      )) {
        return null;
      }

      return nearestObject.copyWith(uniqueName: key) as ProcessGameObject;
    }

    return null;
  }

  ProcessGameObject _findNearestObject(
    Vector2 point,
    Iterable<ProcessGameObject> objects,
  ) {
    if (objects.isEmpty) {
      throw ArgumentError('List of objects is empty');
    }

    ProcessGameObject nearestObject = objects.elementAt(0);
    double minDistance = point.distanceTo(nearestObject.position);

    for (int i = 1; i < objects.length; i++) {
      final element = objects.elementAt(i);
      double distance = point.distanceTo(element.position);

      if (distance < minDistance) {
        minDistance = distance;
        nearestObject = element;
      }
    }

    return nearestObject;
  }
}
