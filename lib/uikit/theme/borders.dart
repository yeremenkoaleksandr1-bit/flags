import 'package:flutter/cupertino.dart';

abstract class ThemeBorders {
  const ThemeBorders._();

  static const ShapeBorder rounded = StadiumBorder();
  static const ShapeBorder small = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}
