import 'dart:math';

extension NumX on num {
  bool isBetween(num lowerBound, num upperBound) {
    return this >= lowerBound && this <= upperBound;
  }

  String get withLeadingZero => (this < 10 ? '0' : '') + toString();

  double roundDouble(int places) {
    final mod = pow(10.0, places);
    return (this * mod).round().toDouble() / mod;
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

int int32MaxValue = 4294967296;
