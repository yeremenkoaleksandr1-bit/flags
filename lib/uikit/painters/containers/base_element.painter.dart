import 'package:flutter/cupertino.dart';

class BaseElementPainter extends CustomPainter {
  final Color background;

  BaseElementPainter({required this.background});

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
