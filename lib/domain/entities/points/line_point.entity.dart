import 'dart:ui';

import 'package:flags/domain/entities/points/base/point_entity.dart';

class SLinePoint implements SPoint {
  @override
  final double x;
  @override
  final double y;

  SLinePoint(this.x, this.y);

  @override
  SLinePoint copyWith({double scale = 1, double? x, double? y}) {
    return SLinePoint(
      x ?? this.x * scale,
      y ?? this.y * scale,
    );
  }

  @override
  void modify(Path path) {
    path.lineTo(x, y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SLinePoint typedOther = other as SLinePoint;
    return typedOther.x == x && typedOther.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'LinePointEntity{x: $x, y: $y}';
  }

  @override
  SLinePoint addPosition(Offset value) {
    return SLinePoint(
      x + value.dx,
      y + value.dy,
    );
  }

  @override
  List<double> get points => [x, y];
}
