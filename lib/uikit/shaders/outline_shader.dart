import 'dart:ui';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class OutlineShader extends StatefulWidget {
  const OutlineShader({
    super.key,
    required this.child,
    this.color = Colors.white,
  });

  final Color color;

  final Widget child;

  @override
  State<OutlineShader> createState() => _OutlineShaderState();
}

class _OutlineShaderState extends State<OutlineShader> {
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
  void didUpdateWidget(covariant OutlineShader oldWidget) {
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

    const value = 1.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        RepaintBoundary(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 0.1,
              sigmaY: 0.1,
              tileMode: TileMode.decal,
            ),
            child: ColorFiltered(
              colorFilter: colorMode,
              child: ImageFiltered(
                imageFilter: ImageFilter.erode(
                  radiusX: value,
                  radiusY: value,
                ),
                child: ColorFiltered(
                  colorFilter: colorMatrix,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                      tileMode: TileMode.decal,
                    ),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.dilate(
                        radiusX: value,
                        radiusY: value,
                      ),
                      child: child,
                    ),
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
