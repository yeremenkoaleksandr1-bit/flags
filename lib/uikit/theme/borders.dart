import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ThemeBorders {
  const ThemeBorders._();

  static BorderRadius get r4 => BorderRadius.all(Radius.circular(4.r));

  static BorderRadius get r8 => BorderRadius.all(Radius.circular(8.r));

  static const ShapeBorder rounded = StadiumBorder();
  static ShapeBorder get small => RoundedRectangleBorder(borderRadius: r8);
}
