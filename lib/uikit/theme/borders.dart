import 'package:flutter/cupertino.dart';

abstract class ThemeBorders {
  const ThemeBorders._();

  static const BorderRadius r4 = BorderRadius.all(
    Radius.circular(4),
  );

  static const BorderRadius r8 = BorderRadius.all(
    Radius.circular(8),
  );

  static const ShapeBorder rounded = StadiumBorder();
  static const ShapeBorder small = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );
}
