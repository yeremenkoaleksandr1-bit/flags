import 'dart:math';

import 'package:flame/extensions.dart';

extension VectorMathExt on Vector2 {
  Vector2 rotate(double angle) {
    final cosTheta = cos(angle);
    final sinTheta = sin(angle);

    return Vector2(
      x * cosTheta - y * sinTheta,
      x * sinTheta + y * cosTheta,
    );
  }

  Vector2 anchoredRotate(double angle, Vector2 anchor) {
    final cosTheta = cos(angle);
    final sinTheta = sin(angle);

    final translatedX = x - anchor.x;
    final translatedY = y - anchor.y;

    final rotatedX = translatedX * cosTheta - translatedY * sinTheta;
    final rotatedY = translatedX * sinTheta + translatedY * cosTheta;

    return Vector2(
      rotatedX + anchor.x,
      rotatedY + anchor.y,
    );
  }

  Vector2 lookAt(Vector2 target) {
    return rotate(
      angleTo(target),
    );
  }

  double angleTo(Vector2 target) {
    final delta = target - this;
    return delta.angleToSigned(Vector2(1, 0)) * pi;
  }
}
