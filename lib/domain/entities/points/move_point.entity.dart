import 'dart:ui';

import 'base/point_entity.dart';

class MovePointEntity implements PointEntity {
  @override
  final double x;
  @override
  final double y;

  MovePointEntity(this.x, this.y);

  @override
  MovePointEntity copyWith({double scale = 1, double? x, double? y}) {
    return MovePointEntity(
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
    final MovePointEntity typedOther = other as MovePointEntity;
    return typedOther.x == x && typedOther.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'MovePointEntity{x: $x, y: $y}';
  }

  @override
  MovePointEntity addPosition(Offset value) {
    return MovePointEntity(
      x + value.dx,
      y + value.dy,
    );
  }

  @override
  List<Object> get props => [x, y];

  @override
  bool? get stringify => true;
}
