import 'package:flags/uikit/theme/input/border.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

export 'borders.dart';
export 'indents.dart';
export 'paddings.dart';
export 'palette.dart';
export 'radius.dart';
export 'text.dart';

abstract class AppTheme {
  static ThemeData get themeData => ThemeData(
        fontFamily: "Troika",
        textTheme: const TextTheme().apply(fontFamily: "Troika"),
        scaffoldBackgroundColor: ThemePalette.transparent,
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: ThemePalette.brown,
        ),
        inputDecorationTheme: InputThemes.common,
      );
}
