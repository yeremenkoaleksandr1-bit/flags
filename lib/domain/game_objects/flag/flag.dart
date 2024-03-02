import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../interfaces/drawable/i_drawable.dart';
import '../base/game_object.dart';
import '../base/process.game_object.dart';
import '../emblems/emblems.dart';

class GameFlag implements IDrawable {
  static Vector2 defaultSize = Vector2.all(64);

  final String name;

  late List<ProcessGameObject> objects;

  final Vector2 size;
  final double proportion;

  GameFlag({
    required this.name,
    required List<ProcessGameObject> Function(Vector2 size) objects,
    required this.proportion,
  }) : size = Vector2(defaultSize.x / proportion, defaultSize.y) {
    this.objects = objects(size);
  }

  @override
  void draw(Canvas canvas, Size size) {
    for (GameObject object in objects) {
      canvas.save();
      if (object is EmblemPart) {
        // canvas.translate(object.size.x / 2, object.size.y / 2);
      }
      object.draw(canvas, size);
      canvas.restore();
    }
  }

  @override
  bool operator ==(dynamic other) => name == other.name;

  @override
  int get hashCode =>
      name.hashCode ^ objects.hashCode ^ size.hashCode ^ proportion.hashCode;

  @override
  String toString() {
    return 'GameFlag{name: $name, objects: $objects, size: $size, proportion: $proportion}';
  }
}
