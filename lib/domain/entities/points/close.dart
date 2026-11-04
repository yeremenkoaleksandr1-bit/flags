import 'dart:ui';

import 'base/point_entity.dart';

class SClosePoint implements SPoint {
  SClosePoint();

  @override
  SClosePoint copyWith({double scale = 1}) {
    return SClosePoint();
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
  SPoint addPosition(Offset value) {
    return this;
  }

  @override
  List<double> get points => [];
}
