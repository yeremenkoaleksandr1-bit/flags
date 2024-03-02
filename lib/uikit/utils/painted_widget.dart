import 'package:flutter/material.dart';

class PaintedWidget extends CustomPaint {
  final void Function(Canvas canvas, Size size) paint;
  final bool Function() shouldRepaint;

  PaintedWidget({
    Key? key,
    super.child,
    required this.paint,
    required this.shouldRepaint,
  }) : super(
            key: key ?? GlobalKey(),
            painter: _Painter(
              paintFn: paint,
              shouldRepaintFn: shouldRepaint,
            ));
}

class _Painter extends CustomPainter {
  final void Function(Canvas canvas, Size size) paintFn;
  final bool Function() shouldRepaintFn;

  _Painter({
    required this.paintFn,
    required this.shouldRepaintFn,
  });

  @override
  void paint(Canvas canvas, Size size) => paintFn(canvas, size);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => shouldRepaintFn();

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
