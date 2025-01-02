import 'package:flame/extensions.dart';
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
    bool flippedVertical = false,
    bool flippedHorizontal = false,
  })  : _flippedHorizontal = flippedHorizontal,
        _flippedVertical = flippedVertical;

  bool _flippedHorizontal;
  bool _flippedVertical;

  // Getters for flipped properties
  bool get flippedHorizontal => _flippedHorizontal;

  bool get flippedVertical => _flippedVertical;

  set flippedHorizontal(bool value) {
    if (_flippedHorizontal != value) {
      _flippedHorizontal = value;
      notifyListeners();
    }
  }

  set flippedVertical(bool value) {
    if (_flippedVertical != value) {
      _flippedVertical = value;
      notifyListeners();
    }
  }

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

    canvas.translate(-this.size.x / 2, -this.size.y / 2);
  }

  FlippableGameObject flipHorizontal() {
    flippedHorizontal = !flippedHorizontal;

    return this;
  }

  FlippableGameObject flipVertical() {
    flippedVertical = !flippedVertical;

    return this;
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
  List<Object?> get props => [
        ...super.props,
        flippedVertical,
        flippedHorizontal,
      ];
}
