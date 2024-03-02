import 'package:flutter/material.dart';

extension SizeX on Size {
  double get centerX => width / 2;

  double get centerY => height / 2;

  Offset get centerOffset => Offset(centerX, centerY);

  Offset get toOffset => Offset(width, height);

  Rect toRect() => Offset.zero & this;

  Size plus(Size size) => Size(width + size.width, height + size.height);
}
