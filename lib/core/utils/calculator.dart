import 'dart:math';
import 'dart:ui';

class Calculator {
  static double fraction(Size original, Size object) {
    return min(original.width / object.width, original.height / object.height);
  }

  static double distance(Offset pos1, Offset pos2) {
    return (pos1 - pos2).distance;
  }

  static Size aspectRatioSize(Size size, double value) {
    return Size(size.width * value, size.height);
  }

  static Offset fittedPosition(
    Offset position,
    Size originalSize,
    Size scaleSize, [
    double percent = 100,
  ]) {
    final percentageTop = ((position.dy)) / scaleSize.height;
    final percentageLeft = ((position.dx)) / scaleSize.width;
    return Offset(
      (percentageLeft * originalSize.width),
      (percentageTop * originalSize.height),
    );
  }

  static Offset viewportTransformation(
    Offset position,
    Size originalSize,
    Size viewSize, [
    double scale = 1,
  ]) {
    final xMax = originalSize.width;
    const yMax = 0;
    const xMin = 0;
    final yMin = originalSize.height;

    final uMax = viewSize.width;
    const vMax = 0;
    const uMin = 0;
    final vMin = viewSize.height;

    return Offset(
      (position.dx - xMin) * ((uMax - uMin) / (xMax - xMin)) + uMin,
      (position.dy - yMin) * ((vMax - vMin) / (yMax - yMin)) + vMin,
    );
  }
}
