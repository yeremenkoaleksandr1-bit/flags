import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ThemePaddings {
  const ThemePaddings._();

  static EdgeInsets get content => EdgeInsets.all(24.r);
  static EdgeInsets get input => EdgeInsets.all(12.r);
  static EdgeInsets get screen => EdgeInsets.all(8.r);
}
