// ignore_for_file: unnecessary_getters_setters

import 'package:flags/domain/interfaces/drawable/i_drawable.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

abstract class GameObject implements IDrawable {
  final Key key;

  final String name;
  final String? uniqueName;

  late Vector2 position;

  late double scale;

  late Vector2 size;

  late double rotation;

  Rect get rect => position & size;

  GameObject({
    Key? key,
    required this.name,
    String? uniqueName,
    Vector2? position,
    Vector2? size,
    this.scale = 1,
    this.rotation = 0,
  })  : key = key ?? UniqueKey(),
        uniqueName = uniqueName ?? UniqueKey().toString(),
        position = position ?? Vector2.zero(),
        size = size ?? Vector2.all(64);

  @protected
  Future<void> init();

  @override
  void draw(Canvas canvas, Size size) {}

  GameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
  });

  bool isEqual(GameObject gameObject) => key == gameObject.key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameObject &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          name == other.name &&
          uniqueName == other.uniqueName &&
          position == other.position &&
          scale == other.scale &&
          size == other.size &&
          rotation == other.rotation;

  @override
  int get hashCode =>
      key.hashCode ^
      name.hashCode ^
      uniqueName.hashCode ^
      position.hashCode ^
      scale.hashCode ^
      size.hashCode ^
      rotation.hashCode;
}

extension GameObjectX on GameObject {
  Rect get rect => Rect.fromLTWH(
        position.x,
        position.y,
        size.x,
        size.y,
      );

// Type get getAbstractType {
//   if (this is IFabric) {
//     if (this is IColoredPathGameObject) {
//       return IColoredPathGameObject;
//     }
//     return IFabric;
//   } else if (this is IEmblem) {
//     return IEmblem;
//   } else {
//     return GameObject;
//   }
// }
}
