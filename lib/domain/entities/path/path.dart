import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flutter/cupertino.dart';
import 'package:memoize/memoize.dart';

import '../../../core/elements/paint.dart';
import '../../../core/utils/utils.dart';
import '../points/points.dart';

// ignore: must_be_immutable
class SPath extends Equatable {
  late Path _path = Path();

  final Rect rect;
  final SPaint paint;
  final List<PointEntity> points;

  SPath({
    required this.paint,
    required this.rect,
    required this.points,
  }) {
    _path = Path();

    for (var point in points) {
      point.modify(_path);
    }
  }

  Rect get bounds => memo0(() => getBounds())();

  Color get color => paint.color;

  factory SPath.fromSvg({
    required String path,
    required SPaint paint,
  }) {
    return parseSvgPathModel(path, paint: paint);
  }

  factory SPath.rect({
    required SPaint paint,
    required Rect rect,
  }) {
    return SPath(
      paint: paint,
      points: [
        PointEntity.move(0, 0),
        PointEntity.line(rect.width, 0),
        PointEntity.line(rect.width, rect.height),
        PointEntity.line(0, rect.height),
        PointEntity.line(0, 0),
      ],
      rect: rect,
    );
  }

  double distance(PointEntity p1, PointEntity p2) {
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    return sqrt(dx * dx + dy * dy);
  }

  // Calculate the mean of distances
  double calculateMean() {
    if (points.isEmpty) {
      return 0.0; // Handle the case of an empty path (no points).
    } else if (points.length == 1) {
      return 0.0; // Handle the case of a single point (returning mean as zero).
    }

    double sum = 0.0;
    for (int i = 1; i < points.length; i++) {
      final dist = distance(points[i - 1], points[i]);
      if (dist.isFinite) {
        sum += dist;
      } else {
        // Handle infinite or NaN distances (optional).
        // You can choose to ignore or handle these cases differently.
      }
    }

    return sum / (points.length - 1);
  }

  // Calculate the standard deviation of distances
  double calculateStdDev(double mean) {
    if (points.isEmpty || points.length == 1) {
      return 0.0; // Handle cases with no or one point.
    }

    double sum = 0.0;
    for (int i = 1; i < points.length; i++) {
      final diff = distance(points[i - 1], points[i]) - mean;
      if (diff.isFinite) {
        sum += diff * diff;
      }
    }

    // Ensure the variance is not negative (avoid square root of a negative number).
    final variance = max(sum / (points.length - 1), 0.0);

    return sqrt(variance);
  }

  bool isSimilarTo(
    SPath other, [
    double meanDeviationThreshold = 20,
    double stdDeviationThreshold = 20,
  ]) {
    final mean1 = calculateMean();
    final stdDev1 = calculateStdDev(mean1);

    final mean2 = other.calculateMean();
    final stdDev2 = other.calculateStdDev(mean2);

    final meanDifference = (mean1 - mean2).abs();
    final stdDevDifference = (stdDev1 - stdDev2).abs();

    return meanDifference <= meanDeviationThreshold &&
        stdDevDifference <= stdDeviationThreshold;
  }

  void _updatePath() {
    _path = Path();

    for (var point in points) {
      point.modify(_path);
    }
    _path.close();
  }

  Path toPath() {
    _updatePath();

    return _path;
  }

  SPath scalePoints(Size size) {
    final fraction = Calculator.fraction(size, rect.size);

    final points = [
      ...this.points.map((e) {
        return e.copyWith(scale: fraction);
      })
    ];

    return copyWith(points: points);
  }

  Rect getBounds() {
    final xValues = points.whereNot((p) => p.x.isNaN).map((p) => p.x);
    final yValues = points.whereNot((p) => p.y.isNaN).map((p) => p.y);

    return Rect.fromLTRB(xValues.min, yValues.min, xValues.max, yValues.max);
  }

  void draw(Canvas canvas, Size size, [SPaint? paint]) {
    canvas.drawPath(_path, (paint ?? this.paint).paint);
  }

  SPath copyWith({
    SPaint? paint,
    Rect? rect,
    List<PointEntity>? points,
  }) {
    return SPath(
      rect: rect ?? this.rect,
      paint: paint ?? this.paint,
      points: points ?? this.points,
    );
  }

  @override
  String toString() {
    return 'PathEntity{rect: $rect, paint: $paint, points: $points}';
  }

  @override
  List<Object> get props => [rect, paint, points];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is SPath &&
          runtimeType == other.runtimeType &&
          _path == other._path &&
          rect == other.rect &&
          paint == other.paint &&
          points == other.points;

  @override
  int get hashCode =>
      super.hashCode ^
      _path.hashCode ^
      rect.hashCode ^
      paint.hashCode ^
      points.hashCode;
}
