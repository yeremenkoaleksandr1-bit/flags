import 'dart:ui';

import 'base/point_entity.dart';

class ClosePath implements PointEntity {
  ClosePath();

  @override
  ClosePath copyWith({double scale = 1}) {
    return ClosePath();
  }

  @override
  void modify(Path path) {
    path.close();
  }

  @override
  String toString() {
    return 'ClosePath{}';
  }

  @override
  double get x => double.nan;

  @override
  double get y => double.nan;

  @override
  PointEntity addPosition(Offset value) {
    return this;
  }

  @override
  List<Object> get props => [];

  @override
  bool? get stringify => true;
}
