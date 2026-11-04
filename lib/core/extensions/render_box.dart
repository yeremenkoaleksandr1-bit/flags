import 'package:flutter/rendering.dart';

extension RenderBoxExtension on RenderBox {
  Rect getRect() {
    final topLeft = localToGlobal(Offset.zero);
    return Rect.fromPoints(topLeft, topLeft.translate(size.width, size.height));
  }
}
