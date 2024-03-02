import 'package:flutter/rendering.dart';

import '../../domain/interfaces/interfaces.dart';

class DrawablePainter extends CustomPainter {
  final IDrawable drawable;

  DrawablePainter(this.drawable);

  @override
  void paint(Canvas canvas, Size size) {
    drawable.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant DrawablePainter oldDelegate) {
    return oldDelegate.drawable != drawable;
  }
}
