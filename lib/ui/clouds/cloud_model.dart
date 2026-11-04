import 'dart:ui';

import 'package:flags/core/path_drawing/path_drawing.dart';

class Cloud {
  Offset position;
  double transparency;

  bool direction;

  double speed;
  double scale;

  late final Path path;
  late final Rect bounds;

  Cloud({
    required String path,
    this.position = Offset.zero,
    this.speed = 10,
    this.transparency = 0.6,
    this.direction = true,
    this.scale = 1,
  }) {
    this.path = parseSvgPathData(path);
    bounds = this.path.getBounds();

    transparency = transparency.clamp(0.6, 0.9);
  }

  void updatePosition(double value) {
    position = Offset(
      position.dx + (direction ? speed : -speed) * value,
      position.dy,
    );
  }

  void changeDirection() {
    direction = !direction;
  }
}
