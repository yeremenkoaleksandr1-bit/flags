import 'package:armar/logger.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flame/game.dart';

import '../../../../domain/game_objects/flag/flag.dart';
import '../../../../domain/game_objects/parts/path_part.dart';
import '../entities/colored_part.game_object.dart';

class PuzzleObjectPlacingHandlerData {}

class PuzzleObjectPlacingHandler {
  final double availableDistance;

  PuzzleObjectPlacingHandler({
    this.availableDistance = 15.0,
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
          (e) {
            final objects = placedObjects.map((e) => e.uniqueName);

            final mustBePlacedLen =
                flag.objects.where((o) => o.uniqueName == e).length;

            final placedObjectsLen =
                placedObjects.where((o) => o.uniqueName == e).length;

            return objects.contains(e) && placedObjectsLen == mustBePlacedLen;
          },
        ) ??
        true;

    if (!isPreviousPlaced) return null;

    var nearestObject =
        _findNearestObject(position / fitValue, objectsFromFlag);

    if (object is ColoredPart && nearestObject is PathPart) {
      if (object.color != nearestObject.color) {
        return null;
      }
    }

    final fittedFlagObjectPosition = nearestObject.position * fitValue;

    if (fittedFlagObjectPosition.distanceTo(position) < availableDistance) {
      if (placedObjects.any(
        (e) =>
            e.position == nearestObject.position &&
            e.uniqueName == nearestObject.uniqueName,
      )) {
        return null;
      }
      final isOriginalObject = object.key == nearestObject.key;

      logger.f(isOriginalObject);
      if (!isOriginalObject) {
        final key = object.key;
        object.key = nearestObject.key;

        return nearestObject.copyWith(
          key: key,
        );
      }

      return nearestObject.copyWith();
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
