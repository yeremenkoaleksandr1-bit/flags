import 'dart:ui';


import '../close.dart';
import '../cubit_point.dart';
import '../line_point.entity.dart';
import '../move_point.entity.dart';

abstract interface class SPoint {
  double get x;

  double get y;

  List<double> get points;

  void modify(Path path);

  SPoint copyWith({double scale});

  SPoint addPosition(Offset value);

  factory SPoint.move(double x, double y) {
    return SMovePoint(x, y);
  }

  factory SPoint.line(double x, double y) {
    return SLinePoint(x, y);
  }

  factory SPoint.cubit(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    return SCubitPoint(x1, y1, x2, y2, x3, y3);
  }

  factory SPoint.close() {
    return SClosePoint();
  }
}
