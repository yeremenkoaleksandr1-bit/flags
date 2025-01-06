import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MagnetAreaView extends StatelessWidget {
  const MagnetAreaView({
    super.key,
    required this.activeHorizontalPosition,
    required this.activeVerticalPosition,
  });

  final bool activeHorizontalPosition;
  final bool activeVerticalPosition;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MagnetAreaPainter(
        activeHorizontalPosition: activeHorizontalPosition,
        activeVerticalPosition: activeVerticalPosition,
      ),
    );
  }
}

class _MagnetAreaPainter extends CustomPainter with EquatableMixin {
  final bool activeHorizontalPosition;
  final bool activeVerticalPosition;

  _MagnetAreaPainter({
    super.repaint,
    required this.activeHorizontalPosition,
    required this.activeVerticalPosition,
  });

  final Paint blueLinePaint = Paint()
    ..color = Colors.blueAccent
    ..strokeWidth = 1.2;

  final Paint redLinePaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    if (activeHorizontalPosition) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        blueLinePaint,
      );
    }

    if (activeVerticalPosition) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        blueLinePaint,
      );
    }

    // canvas.drawLine(
    //   const Offset(0, 0),
    //   Offset(size.width, size.height),
    //   redLinePaint,
    // );
    //
    // canvas.drawLine(
    //   Offset(size.width, 0),
    //   Offset(0, size.height),
    //   redLinePaint,
    // );
  }

  @override
  bool shouldRepaint(covariant _MagnetAreaPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        activeHorizontalPosition,
        activeVerticalPosition,
      ];
}
