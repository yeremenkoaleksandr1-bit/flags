import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/parts/path_part.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flame/game.dart';

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

    if (objectsFromFlag.isEmpty) {
      return null;
    }

    final isPreviousPlaced = object.previousMustBePlaced?.every(
          (e) {
            final objects = placedObjects.map((e) => e.uniqueName);
            final objectsByName = placedObjects.map((e) => e.name);

            final mustBePlacedLen = flag.objects
                .where((o) => o.uniqueName == e || o.name == e)
                .length;

            final placedObjectsLen = placedObjects
                .where((o) => o.uniqueName == e || o.name == e)
                .length;

            return (objects.contains(e) || objectsByName.contains(e)) &&
                placedObjectsLen == mustBePlacedLen;
          },
        ) ??
        true;

    if (!isPreviousPlaced) {
      return null;
    }

    final nearestObject =
        _findNearestObject(position / fitValue, objectsFromFlag);

    if (object is ColoredPart && nearestObject is PathGameObject) {
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

      return nearestObject.copyWith(
        key: object.key,
        uniqueName: object.uniqueName,
      );
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
      final double distance = point.distanceTo(element.position);

      if (distance < minDistance) {
        minDistance = distance;
        nearestObject = element;
      }
    }

    return nearestObject;
  }
}
