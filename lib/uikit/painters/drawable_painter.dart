import 'package:flutter/cupertino.dart';

import '../../domain/interfaces/interfaces.dart';

class DrawablePaint extends CustomPaint {
  DrawablePaint({
    super.key,
    required IDrawable drawable,
    Size? size,
  }) : super(
          size: size ?? Size.zero,
          painter: DrawablePainter(drawable),
        );
}

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
