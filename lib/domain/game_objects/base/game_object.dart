// ignore_for_file: unnecessary_getters_setters

import 'package:flags/domain/interfaces/drawable/i_drawable.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

abstract class GameObject
    with ChangeNotifier
    implements IDrawable, IDisposable {
  Key key;
  String name;
  String? uniqueName;

  Vector2 _position;
  double _scale;
  Vector2 _size;
  double _rotation;

  GameObject({
    Key? key,
    required this.name,
    String? uniqueName,
    Vector2? position,
    Vector2? size,
    double scale = 1,
    double rotation = 0,
  })  : key = key ?? UniqueKey(),
        uniqueName = uniqueName ?? name,
        _position = position ?? Vector2.zero(),
        _size = size ?? Vector2.all(64),
        _scale = scale,
        _rotation = rotation;

  // Getters
  Vector2 get position => _position;

  double get scale => _scale;

  Vector2 get size => _size;

  double get rotation => _rotation;

  set position(Vector2 newPosition) {
    if (_position != newPosition) {
      _position = newPosition;
      notifyListeners();
    }
  }

  set scale(double newScale) {
    if (_scale != newScale) {
      _scale = newScale;
      notifyListeners();
    }
  }

  set size(Vector2 newSize) {
    if (_size != newSize) {
      _size = newSize;
      notifyListeners();
    }
  }

  set rotation(double newRotation) {
    if (_rotation != newRotation) {
      _rotation = newRotation;
      notifyListeners();
    }
  }

  Rect get rect => _position & _size;

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
      other is GameObject &&
      runtimeType == other.runtimeType &&
      key == other.key &&
      name == other.name &&
      uniqueName == other.uniqueName &&
      _position == other._position &&
      _scale == other._scale &&
      _size == other._size &&
      _rotation == other._rotation;

  @override
  int get hashCode =>
      key.hashCode ^
      name.hashCode ^
      uniqueName.hashCode ^
      _position.hashCode ^
      _scale.hashCode ^
      _size.hashCode ^
      _rotation.hashCode;
}

extension GameObjectX on GameObject {
  Rect get rect => Rect.fromLTWH(
        position.x,
        position.y,
        size.x,
        size.y,
      );

  Matrix4 get transformationMatrix => Matrix4.identity()
    ..translate(size.x / 2, size.y / 2)
    ..rotateZ(rotation)
    ..scale(scale)
    ..translate(-size.x / 2, -size.y / 2);

  Matrix4 transformFromCenterMatrix(Matrix4 matrix) => Matrix4.identity()
    ..translate(size.x / 2, size.y / 2)
    ..add(matrix)
    ..translate(-size.x / 2, -size.y / 2);

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
