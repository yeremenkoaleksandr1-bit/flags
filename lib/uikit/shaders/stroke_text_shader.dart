import 'dart:ui';

import 'package:flags/uikit/shaders/shaders.dart';
import 'package:flutter/material.dart';

final class StrokeTextShader {
  StrokeTextShader._();

  static Shader create({
    required Rect bounds,
    required Color color,
  }) {
    final shader = GameShaders.strokeText.fragmentShader();
    final width = bounds.width <= 0 ? 1.0 : bounds.width;
    final height = bounds.height <= 0 ? 1.0 : bounds.height;

    shader
      ..setFloat(0, width)
      ..setFloat(1, height)
      ..setFloat(2, color.r)
      ..setFloat(3, color.g)
      ..setFloat(4, color.b)
      ..setFloat(5, color.a);

    return shader;
  }
}
