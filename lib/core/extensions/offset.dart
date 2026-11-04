import 'dart:math';

import 'package:flutter/animation.dart';

extension OffsetExt on Offset {
  double distanceTo(Offset arg) => sqrt(distanceToSquared(arg));

  double distanceToSquared(Offset arg) {
    final dx = this.dx - arg.dx;
    final dy = this.dy - arg.dy;

    return dx * dx + dy * dy;
  }

  Offset median(Offset point) {
    return Offset((dx + point.dx) / 2, (dy + point.dy) / 2);
  }

  double angle(Offset point) {
    return atan2(point.dy - dy, point.dx - dx);
  }

  Offset directionTo(Offset point) {
    return Offset(point.dx - dx, point.dy - dy);
  }

  Offset normalizedDirectionTo(Offset point) {
    final dir = directionTo(point);

    final length = sqrt(dir.dx * dir.dx + dir.dy * dir.dy);

    return Offset(dir.dx / length, dir.dy / length);
  }
}

class OVector {
  final Offset p1;
  final Offset p2;

  OVector(this.p1, this.p2);

  Offset get median {
    return p1.median(p2);
  }

  double get angle {
    return p1.angle(p2);
  }

  Offset get direction {
    return p1.directionTo(p2);
  }

  Offset get normalizedDirection {
    return p1.normalizedDirectionTo(p2);
  }

  Offset createPointFromDirection(Offset point, double distance) {
    final normalDir = Offset(normalizedDirection.dy, -normalizedDirection.dx);
    return Offset(
      point.dx + normalDir.dx * distance,
      point.dy + normalDir.dy * distance,
    );
  }
}

class BezierCurve {
  final Offset p1;
  final Offset p2;
  final Offset p3;
  final Offset p4;

  BezierCurve(
    this.p1,
    this.p2,
    this.p3,
    this.p4,
  );

  factory BezierCurve.fromVector(Offset start, Offset end, double distance) {
    final m = start.median(end);
    final m1 = m.median(start);
    final m2 = m.median(end);

    var normalizedDirection = start.normalizedDirectionTo(end);

    normalizedDirection = Offset(
      normalizedDirection.dy,
      -normalizedDirection.dx,
    );

    final p1 = Offset(
      m1.dx + normalizedDirection.dx * distance,
      m1.dy + normalizedDirection.dy * distance,
    );
    final p2 = Offset(
      m2.dx + normalizedDirection.dx * distance,
      m2.dy + normalizedDirection.dy * distance,
    );

    return BezierCurve(start, p1, p2, end);
  }

  late final List<Offset> points = [p1, p2, p3, p4];

  Offset moveByLerp(double t) {
    return Offset.lerp(
      Offset.lerp(p1, p2, t),
      Offset.lerp(p3, p4, t),
      t,
    )!;
  }

  Offset lerp(double time, [Curve curve = Curves.linear]) {
    final t = curve.transform(time);

    // Bernstein polynomial for cubic Bezier curve
    final double mt = 1 - t;
    final double mt2 = mt * mt;
    final double mt3 = mt2 * mt;
    final double t2 = t * t;
    final double t3 = t2 * t;

    // Calculate position using the Bernstein polynomial formula
    final double x =
        p1.dx * mt3 + 3 * p2.dx * mt2 * t + 3 * p3.dx * mt * t2 + p4.dx * t3;
    final double y =
        p1.dy * mt3 + 3 * p2.dy * mt2 * t + 3 * p3.dy * mt * t2 + p4.dy * t3;

    return Offset(x, y);
  }
}
