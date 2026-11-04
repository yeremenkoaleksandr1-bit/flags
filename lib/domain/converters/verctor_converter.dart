import 'package:flame/components.dart';

extension VectorConverter on Vector2 {
  List<double> toJson() => [x, y];

  Vector2 fromJson(List<double> list) => Vector2(list[0], list[1]);
}
