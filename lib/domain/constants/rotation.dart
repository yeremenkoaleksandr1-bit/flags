import 'dart:math' as math;

base class RotationConstants {
  const RotationConstants._();

  static Set<double> assistAngles = <double>{
    0,
    math.pi / 4,
    math.pi / 2,
    3 * math.pi / 4,
    math.pi,
    5 * math.pi / 4,
    3 * math.pi / 2,
    7 * math.pi / 4,
    2 * math.pi
  };
}
