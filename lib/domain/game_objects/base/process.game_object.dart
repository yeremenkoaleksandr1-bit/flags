import 'game_object.dart';

abstract class ProcessGameObject extends GameObject {
  ProcessGameObject({
    super.key,
    super.uniqueName,
    required super.name,
    super.position,
    super.rotation,
    super.scale,
    super.size,
    List<String>? previousMustBePlaced,
  }) : _previousMustBePlaced = previousMustBePlaced;

  final List<String>? _previousMustBePlaced;

  List<String>? get previousMustBePlaced => _previousMustBePlaced != null
      ? List.unmodifiable(_previousMustBePlaced)
      : null;
}
