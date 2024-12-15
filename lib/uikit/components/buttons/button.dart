import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FButton extends StatelessWidget {
  const FButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.padding = const Pad(all: 8),
  });

  final Color color;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  final EdgeInsets padding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ScaledGestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        child: CustomPaint(
          painter: CustomButtonPainter(
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.modulate,
            ),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomButtonPainter extends CustomPainter {
  final ColorFilter colorFilter;

  CustomButtonPainter({
    required this.colorFilter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base rectangle fill
    final fillPaint = Paint()
      ..color = const Color(0xFFFFFFFF) // Light gray color
      ..style = PaintingStyle.fill
      ..colorFilter = colorFilter;

    const borderRadius = BorderRadius.all(Radius.circular(8));
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);
    canvas.drawRRect(rrect, fillPaint);

    // Stroke for the base rectangle
    final strokePaint = Paint()
      ..color = const Color(0xFFD5D5D5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..colorFilter = colorFilter;
    canvas.drawRRect(rrect.deflate(1), strokePaint);

    // Inner rectangle
    const double padding = 6.0;
    final innerRect = Rect.fromLTWH(
      padding,
      size.height - size.height / 2.5 - padding,
      size.width - padding * 2,
      size.height / 2.5,
    );

    final innerRrect = const BorderRadius.all(
      Radius.circular(4),
    ).toRRect(innerRect);

    final innerFillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFEEEEEE), // Top color
          const Color(0xFFEEEEEE).withOpacity(0.0), // Bottom transparent color
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(innerRect)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.multiply;
    canvas.drawRRect(innerRrect, innerFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomButtonPainter oldDelegate) {
    return colorFilter != oldDelegate.colorFilter;
  }
}
