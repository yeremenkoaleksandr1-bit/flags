import 'dart:math' as math;

import 'package:flutter/material.dart';

extension TransformWidgetX on Widget {
  Transform translateOnly({
    double x = 0,
    double y = 0,
  }) =>
      Transform.translate(
        offset: Offset(x, y),
        child: this,
      );

  Transform translate(Offset offset) => Transform.translate(
        offset: offset,
        child: this,
      );

  Transform scale(double scale) => Transform.scale(
        scale: scale,
        child: this,
      );

  Transform rotate(double angle) => Transform.rotate(
        angle: angle,
        child: this,
      );

  Transform transform({
    Alignment alignment = Alignment.center,
    double rotate = 0,
    double scale = 1,
    double x = 0,
    double y = 0,
  }) =>
      Transform(
        alignment: alignment,
        transform: Matrix4.identity()
          ..scale(scale)
          ..translate(x, y)
          ..rotateZ(rotate * math.pi / 180),
        child: this,
      );
}
