import 'dart:ui';

import 'package:flags/domain/entities/points/base/point_entity.dart';

class SCubitPoint implements SPoint {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x3;
  final double y3;

  SCubitPoint(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);

  @override
  SCubitPoint copyWith({
    double? x1,
    double? y1,
    double? x2,
    double? y2,
    double? x3,
    double? y3,
    double scale = 1,
  }) {
    return SCubitPoint(
      (x1 ?? this.x1) * scale,
      (y1 ?? this.y1) * scale,
      (x2 ?? this.x2) * scale,
      (y2 ?? this.y2) * scale,
      (x3 ?? this.x3) * scale,
      (y3 ?? this.y3) * scale,
    );
  }

  @override
  void modify(Path path) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SCubitPoint typedOther = other as SCubitPoint;
    return typedOther.x1 == x1 &&
        typedOther.y1 == y1 &&
        typedOther.x2 == x2 &&
        typedOther.y2 == y2 &&
        typedOther.x3 == x3 &&
        typedOther.y3 == y3;
  }

  @override
  int get hashCode =>
      x1.hashCode ^
      y1.hashCode ^
      x2.hashCode ^
      y2.hashCode ^
      x3.hashCode ^
      y3.hashCode;

  @override
  String toString() {
    return 'CubitPointEntity{x1: $x1, y1: $y1, x2: $x2, y2: $y2, x3: $x3, y3: $y3}';
  }

  @override
  double get x => x2;

  @override
  double get y => y2;

  @override
  SCubitPoint addPosition(Offset value) {
    return SCubitPoint(
      x1 + value.dx,
      y1 + value.dy,
      x2 + value.dx,
      y2 + value.dy,
      x3 + value.dx,
      y3 + value.dy,
    );
  }

  @override
  List<double> get points => [x1, y1, x2, y2, x3, y3];
}
