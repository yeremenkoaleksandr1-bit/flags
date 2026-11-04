
import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class RectX {
  static Rect fromSize(Size size) {
    return Offset.zero & size;
  }
}

extension RectExt on Rect {
  double get centerX => width / 2;

  double get centerY => height / 2;
}

extension RectListX on List<Rect> {
  Rect get getBounds {
    if (isEmpty) {
      return Rect.zero;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final rect in this) {
      minX = rect.left < minX ? rect.left : minX;
      minY = rect.top < minY ? rect.top : minY;
      maxX = rect.right > maxX ? rect.right : maxX;
      maxY = rect.bottom > maxY ? rect.bottom : maxY;
    }

    debugPrint(Rect.fromLTRB(minX, minY, maxX, maxY).toString());


    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
