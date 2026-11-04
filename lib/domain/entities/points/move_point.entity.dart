import 'dart:ui';

import 'package:flags/domain/entities/points/base/point_entity.dart';

class SMovePoint implements SPoint {
  @override
  final double x;
  @override
  final double y;

  SMovePoint(this.x, this.y);

  @override
  SMovePoint copyWith({double scale = 1, double? x, double? y}) {
    return SMovePoint(
      x ?? this.x * scale,
      y ?? this.y * scale,
    );
  }

  @override
  void modify(Path path) {
    path.moveTo(x, y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final SMovePoint typedOther = other as SMovePoint;
    return typedOther.x == x && typedOther.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'MovePointEntity{x: $x, y: $y}';
  }

  @override
  SMovePoint addPosition(Offset value) {
    return SMovePoint(
      x + value.dx,
      y + value.dy,
    );
  }

  @override
  List<double> get points => [x, y];
}
