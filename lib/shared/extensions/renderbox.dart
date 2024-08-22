import 'package:flutter/material.dart';

extension RenderBoxExtensions on RenderBox {
  Rect get globalBounds {
    final topLeft = localToGlobal(Offset.zero);
    final bottomRight = localToGlobal(size.bottomRight(Offset.zero));
    return Rect.fromPoints(topLeft, bottomRight);
  }
}
