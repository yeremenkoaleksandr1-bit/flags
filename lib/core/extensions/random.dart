import 'dart:math';

extension RandomExtensions on Random {
  int nextIntRange(int min, int max) {
    return min + nextInt(max - min);
  }
}
