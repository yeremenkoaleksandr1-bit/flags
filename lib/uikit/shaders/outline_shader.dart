import 'dart:ui';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class OutlineWidget extends StatefulWidget {
  const OutlineWidget({
    super.key,
    required this.child,
    this.color = Colors.white,
  });

  final Color color;

  final Widget child;

  @override
  State<OutlineWidget> createState() => _OutlineWidgetState();
}

class _OutlineWidgetState extends State<OutlineWidget> {
  final result = [
    ...[0, 0, 0, 0, 0],
    ...[0, 0, 0, 0, 0],
    ...[0, 0, 0, 0, 0],
    ...[1, 1, 1, 10, 0],
  ].map((e) => e.toDouble());

  late ColorFilter colorMode = ColorFilter.mode(
    widget.color,
    BlendMode.srcIn,
  );

  late final colorMatrix = ColorFilter.matrix([...result]);

  @override
  void didUpdateWidget(covariant OutlineWidget oldWidget) {
    if (oldWidget.color != widget.color) {
      colorMode = ColorFilter.mode(
        widget.color,
        BlendMode.srcIn,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        RepaintBoundary(
          child: ColorFiltered(
            colorFilter: colorMode,
            child: ImageFiltered(
              imageFilter: ImageFilter.erode(
                radiusX: 4,
                radiusY: 4,
              ),
              child: ColorFiltered(
                colorFilter: colorMatrix,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 1,
                    sigmaY: 1,
                    tileMode: TileMode.decal,
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.dilate(
                      radiusX: 4,
                      radiusY: 4,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class ShaderPainter extends CustomPainter {
  final UIImage image;

  ShaderPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    // canvas.drawPaint(Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
