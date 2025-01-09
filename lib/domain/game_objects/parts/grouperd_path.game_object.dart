import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/domain/game_objects/parts/path_part.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:memoize/memoize.dart';

class GroupedPathsPart extends ProcessGameObject {
  GroupedPathsPart({
    super.key,
    required super.name,
    super.uniqueName,
    required List<PathGameObject> Function(Vector2 size) objects,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.previousMustBePlaced,
  }) : objects = objects(size ?? Vector2.all(64));

  late final List<PathGameObject> objects;

  @override
  Vector2 get size => _bounds.size.toVector2();

  @override
  void draw(Canvas canvas, Size size, [double fraction = 1]) {
    super.draw(canvas, size);

    drawObjects(canvas, size);
  }

  void drawObjects(Canvas canvas, Size size) {
    for (final object in objects) {
      canvas.save();
      canvas.translate(object.position.x, object.position.y);
      object.draw(canvas, size);
      canvas.restore();
    }
  }

  late final Rect _bounds = [...objects.map((e) => e.bounds)].getBounds;

  late final _fraction = memo1(
    (Size size) => Calculator.fraction(
      size,
      _bounds.size,
    ),
  );

  Rect get bounds => _bounds;

  void drawPart(Canvas canvas, Size size) {
    super.draw(canvas, size);

    canvas.scale(_fraction(size));

    drawObjects(canvas, size);
  }

  @override
  Future<void> init() async => this;

  @override
  GroupedPathsPart copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    List<PathGameObject>? objects,
    Vector2? position,
    double? rotation,
    double? scale,
    Vector2? size,
  }) {
    return GroupedPathsPart(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: uniqueName ?? this.uniqueName,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      objects: (size) => objects ?? this.objects,
      previousMustBePlaced: previousMustBePlaced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is GroupedPathsPart &&
          runtimeType == other.runtimeType &&
          objects == other.objects;

  @override
  int get hashCode => super.hashCode ^ objects.hashCode;
}
