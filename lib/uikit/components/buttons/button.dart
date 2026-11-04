import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FButton extends StatelessWidget {
  const FButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.padding,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  final Color color;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  final EdgeInsets? padding;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ScaledGestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        enableHapticFeedback: enableHapticFeedback,
        enableSoundFeedback: enableSoundFeedback,
        child: CustomPaint(
          painter: CustomButtonPainter(
            colorFilter: ColorFilter.mode(color, BlendMode.modulate),
            color: color,
          ),
          child: Padding(padding: padding ?? EdgeInsets.all(8.r), child: child),
        ),
      ),
    );
  }
}

class CustomButtonPainter extends CustomPainter {
  final ColorFilter colorFilter;

  /// Button base color (the fill is white modulated by this color).
  final Color color;

  CustomButtonPainter({required this.colorFilter, required this.color});

  /// Shade of the gradient that used to be blended with [BlendMode.overlay].
  static const double _overlayShade = 0x59 / 255;

  /// Result of `BlendMode.overlay` of [_overlayShade] grey over [base].
  ///
  /// Overlay is an "advanced" blend mode that Skia (Android < 10, e.g.
  /// BlueStacks) does not render correctly on some GPUs: the grey gradient was
  /// drawn as-is and showed up as a dark band on every button. Computing the
  /// blended color up front and drawing it with normal alpha blending looks
  /// the same on Impeller and works everywhere.
  static Color _overlayOf(Color base) {
    double channel(double d) => d <= 0.5
        ? 2 * _overlayShade * d
        : 1 - 2 * (1 - _overlayShade) * (1 - d);

    return Color.from(
      alpha: 1,
      red: channel(base.r),
      green: channel(base.g),
      blue: channel(base.b),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill
      ..colorFilter = colorFilter;

    final borderRadius = BorderRadius.all(Radius.circular(8.r));
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);
    canvas.drawRRect(rrect, fillPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFFD5D5D5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.r
      ..colorFilter = colorFilter;
    canvas.drawRRect(rrect.deflate(1), strokePaint);

    final double padding = 6.r;
    final innerRect = Rect.fromLTWH(
      padding,
      size.height - size.height / 2.5 - padding,
      size.width - padding * 2,
      size.height / 2.5,
    );

    final innerRrect = BorderRadius.all(
      Radius.circular(4.r),
    ).toRRect(innerRect);

    final overlayColor = _overlayOf(color);
    final innerFillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          overlayColor,
          overlayColor.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(innerRect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(innerRrect, innerFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomButtonPainter oldDelegate) {
    return colorFilter != oldDelegate.colorFilter ||
        color != oldDelegate.color;
  }
}
