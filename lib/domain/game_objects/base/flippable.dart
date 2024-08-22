import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';

import 'process.game_object.dart';

abstract class FlippableGameObject extends ProcessGameObject {
  FlippableGameObject({
    super.key,
    required super.name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.uniqueName,
    super.previousMustBePlaced,
    this.flippedVertical = false,
    this.flippedHorizontal = false,
  });

  final bool flippedHorizontal;

  final bool flippedVertical;

  @override
  FlippableGameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    bool? flippedHorizontal,
    bool? flippedVertical,
  });

  @override
  void draw(Canvas canvas, Size size) {
    canvas.translate(
      position.x + this.size.x / 2,
      position.y + this.size.y / 2,
    );

    canvas.rotate(rotation);
    canvas.scale(scale);

    canvas.scale(
      (flippedHorizontal ? -1 : 1),
      (flippedVertical ? -1 : 1),
    );

    canvas.translate(-this.size.x / 2, -this.size.y / 2);
  }

  FlippableGameObject flipHorizontal() {
    return copyWith(flippedHorizontal: !flippedHorizontal);
  }

  FlippableGameObject flipVertical() {
    return copyWith(flippedVertical: !flippedVertical);
  }

  @override
  String toString() {
    return 'FlippableGameObject{'
        '\ntype: $runtimeType,'
        '\nkey: $key,'
        '\nname: $name,'
        '\nposition: $position,'
        '\nscale: $scale,'
        '\nsize: $size,'
        '\nrotation.dart: $rotation,'
        '\nflippedHorizontal: $flippedHorizontal,'
        '\nflippedVertical: $flippedVertical\n}';
  }

  @override
  bool operator ==(Object other) {
    if (other is! FlippableGameObject) return false;

    return super == other &&
        flippedVertical == other.flippedVertical &&
        flippedHorizontal == other.flippedHorizontal;
  }

  @override
  int get hashCode =>
      super.hashCode ^ flippedVertical.hashCode ^ flippedHorizontal.hashCode;
}
