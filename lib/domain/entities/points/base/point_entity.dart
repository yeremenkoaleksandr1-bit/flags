import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../close.dart';
import '../cubit_point.dart';
import '../line_point.entity.dart';
import '../move_point.entity.dart';

abstract class PointEntity extends Equatable {
  double get x;

  double get y;

  void modify(Path path);

  PointEntity copyWith({double scale});

  PointEntity addPosition(Offset value);

  factory PointEntity.move(double x, double y) {
    return MovePointEntity(x, y);
  }

  factory PointEntity.line(double x, double y) {
    return LinePointEntity(x, y);
  }

  factory PointEntity.cubit(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    return CubitPointEntity(x1, y1, x2, y2, x3, y3);
  }

  factory PointEntity.close() {
    return ClosePath();
  }

  @override
  List<Object> get props => [x, y];
}
