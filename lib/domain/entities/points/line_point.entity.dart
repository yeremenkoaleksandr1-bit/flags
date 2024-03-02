import 'dart:ui';

import 'base/point_entity.dart';

class LinePointEntity implements PointEntity {
  @override
  final double x;
  @override
  final double y;

  LinePointEntity(this.x, this.y);

  @override
  LinePointEntity copyWith({double scale = 1, double? x, double? y}) {
    return LinePointEntity(
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
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final LinePointEntity typedOther = other as LinePointEntity;
    return typedOther.x == x && typedOther.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'LinePointEntity{x: $x, y: $y}';
  }

  @override
  LinePointEntity addPosition(Offset value) {
    return LinePointEntity(
      x + value.dx,
      y + value.dy,
    );
  }

  @override
  List<Object> get props => [x, y];

  @override
  bool? get stringify => true;
}
