// ignore_for_file: must_be_immutable
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/foundation.dart';

import '../../entities/path/path.dart';

class ShapeGameObject extends GameObject {
  final SPath path;

  ShapeGameObject({
    super.key,
    required super.name,
    super.uniqueName,
    super.position,
    super.size,
    super.scale,
    super.rotation,
    required this.path,
  });

  @override
  void draw(Canvas canvas, Size size, [double fraction = 1]) {
    drawPart(canvas, size);
  }

  void drawPart(Canvas canvas, Size size) {
    super.draw(canvas, size);

    canvas.scale(
      this.size.x / path.bounds.width,
      this.size.y / path.bounds.height,
    );

    path.draw(canvas, size);
  }

  @override
  ShapeGameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    SPath? path,
  }) {
    SPath? path0;

    if (size != null) {
      path0 = this.path.copyWith(rect: size.toRect());
    }

    return ShapeGameObject(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: uniqueName ?? this.uniqueName,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      path: path ?? (path0 ?? this.path),
    );
  }

  @override
  Future<void> init() async {}
}
