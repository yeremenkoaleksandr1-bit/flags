import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

typedef PathBuilder = Path Function(Size);

class DashedShapeBorder extends ShapeBorder {
  final double strokeWidth;
  final List<double> dashPattern;
  final Color color;
  final BorderRadius borderRadius;
  final PathBuilder? customPath;

  DashedShapeBorder({
    this.strokeWidth = 1,
    this.dashPattern = const <double>[2, 2],
    this.color = Colors.black,
    this.borderRadius = BorderRadius.zero,
    this.customPath,
  }) {
    assert(dashPattern.isNotEmpty, 'Dash Pattern cannot be empty');
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(5);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
    );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
    );

  late final Paint _paint = Paint()
    ..strokeWidth = strokeWidth
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(_getPath(rect.size), _paint);
  }

  @override
  ShapeBorder scale(double t) => this;

  Path _getPath(Size size) {
    return dashPath(
      _getRRectPath(size, borderRadius),
      dashArray: CircularIntervalList(dashPattern),
    );
  }

  Path _getRRectPath(Size size, BorderRadius radius) {
    final padding = strokeWidth;
    return Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            padding,
            padding,
            size.width - strokeWidth * 2,
            size.height - strokeWidth * 2,
          ),
          topLeft: radius.topLeft,
          topRight: radius.topRight,
          bottomLeft: radius.bottomLeft,
          bottomRight: radius.bottomRight,
        ),
      );
  }
}
