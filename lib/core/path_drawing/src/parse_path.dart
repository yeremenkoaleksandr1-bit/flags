import 'dart:ui' show Offset, Paint, Path, Rect, Size;

import 'package:path_parsing/path_parsing.dart';

import '../../../domain/entities/path/path.dart';
import '../../../domain/entities/points/base/point_entity.dart';
import '../../elements/paint.dart';
import '../../utils/utils.dart';

/// Creates a [Path] object from an SVG data string.
///
/// Passing an empty string will result in an empty path.
Path parseSvgPathData(String svg) {
  if (svg == '') {
    return Path();
  }

  final SvgPathStringSource parser = SvgPathStringSource(svg);
  final FlutterPathProxy path = FlutterPathProxy();
  final SvgPathNormalizer normalizer = SvgPathNormalizer();
  for (PathSegmentData seg in parser.parseSegments()) {
    normalizer.emitSegment(seg, path);
  }
  return path.path;
}

SPath parseSvgPathModel(
  String svg, {
  SPaint? paint,
  Size size = const Size.square(64),
}) {
  if (svg == '') {
    return SPath(
      points: [],
      paint: paint ?? SPaint(),
      rect: RectX.fromSize(size),
    );
  }

  final SvgPathStringSource parser = SvgPathStringSource(svg);
  final PathModelProxy path = PathModelProxy();
  final SvgPathNormalizer normalizer = SvgPathNormalizer();
  for (PathSegmentData seg in parser.parseSegments()) {
    normalizer.emitSegment(seg, path);
  }

  return path.model.copyWith(rect: path.model.bounds, paint: paint ?? SPaint());
}

class PathModelProxy extends PathProxy {
  final SPath model;

  PathModelProxy()
      : model = SPath(
          points: [],
          paint: SPaint(),
          rect: Rect.zero,
        );

  @override
  void close() {
    model.points.add(PointEntity.close());
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    model.points.add(PointEntity.cubit(x1, y1, x2, y2, x3, y3));
  }

  @override
  void lineTo(double x, double y) {
    model.points.add(PointEntity.line(x, y));
  }

  @override
  void moveTo(double x, double y) {
    model.points.add(PointEntity.move(x, y));
  }
}

class FlutterPathProxy extends PathProxy {
  FlutterPathProxy({Path? p}) : path = p ?? Path();

  final Path path;

  @override
  void close() {
    path.close();
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
  }
}
