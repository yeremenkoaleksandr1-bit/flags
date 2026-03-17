import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ThemeRadius {
  const ThemeRadius._();

  static double get r4 => 4.r;
  static BorderRadius get r4b => BorderRadius.all(Radius.circular(r4));
  static double get r12 => 12.r;
  static double get r16 => 16.r;
}
