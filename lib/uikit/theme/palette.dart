import 'dart:ui';

abstract class ThemePalette {
  const ThemePalette._();

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color gray = Color(0xffbfbfbf);
  static const Color transparent = Color(0x00000000);

  static const Color yellow = Color(0xffF6CF46);
  static const Color orange = Color(0xffFFA236);
  static const Color green = Color(0xffC1D528);
  static const Color pink = Color(0xffFE6C8F);
  static const Color red = Color(0xffFD4B38);
  static const Color blue = Color(0xff6CC4EE);

  static const Color peachCard = Color(0xffffe8bf);
  static const Color peach = Color(0xffEED8B3);

  static const Color gentleYellow = Color(0xffEFEACF);

  static const Color redAccent = Color(0xffED1C24);

  static const Color blueButton = Color(0xFF2691F5);
  static const Color greenButton = Color(0xFF5ACC13);
  static const Color redButton = Color(0xFFE45844);
  static const Color redDarkButton = Color(0xffE4392B);
  static const Color yellowButton = Color(0xFFFDC840);
  static const Color orangeButton = Color(0xffFC9D23);
}

abstract class ColorFilters {
  static ColorFilter get topHighlight => const ColorFilter.matrix([
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);

  static ColorFilter get invert => const ColorFilter.matrix([
        -1,
        0,
        0,
        0,
        255,
        0,
        -1,
        0,
        0,
        255,
        0,
        0,
        -1,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]);

  static ColorFilter get sepia => const ColorFilter.matrix([
        0.393,
        0.769,
        0.189,
        0,
        0,
        0.349,
        0.686,
        0.168,
        0,
        0,
        0.272,
        0.534,
        0.131,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);

  static ColorFilter get greyscale => const ColorFilter.matrix([
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);
}
