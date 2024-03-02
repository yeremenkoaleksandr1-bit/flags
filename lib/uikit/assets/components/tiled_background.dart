import 'package:flutter/material.dart';

class TiledBackground extends CustomPaint {
  TiledBackground({super.key})
      : super(
          painter: _Painter(),
        );
}

class _Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff55bbeb)
      ..strokeWidth = 64
      ..style = PaintingStyle.stroke;

    for (double i = 0; i <= size.width; i += 64 * 2) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
