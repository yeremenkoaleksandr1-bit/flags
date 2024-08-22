import 'package:flags/uikit/theme/theme.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

base class InputThemes {
  static InputDecorationTheme get common {
    final color = ThemePalette.peachCard.darken(0.3);

    return InputDecorationTheme(
      filled: true,
      counterStyle: const TextStyle(
        color: ThemePalette.white,
      ),
      hintStyle: const TextStyle(
        color: ThemePalette.black,
      ),
      suffixIconColor: color,
      prefixIconColor: color,
      fillColor: ThemePalette.transparent,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isCollapsed: true,
      contentPadding: ThemePaddings.input,
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: Color(0xff3F434B),
        ),
        borderRadius: ThemeBorders.r8,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: color,
        ),
        borderRadius: ThemeBorders.r8,
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.8,
          color: ThemePalette.redDarkButton,
        ),
        borderRadius: ThemeBorders.r8,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.8,
          color: color,
        ),
        borderRadius: ThemeBorders.r8,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: color,
        ),
        borderRadius: ThemeBorders.r8,
      ),
    );
  }
//
// static InputDecorationTheme stadium = common.copyWith(
//   border: const OutlineInputBorder(
//     borderSide: BorderSide(
//       color: Color(0xff3F434B),
//     ),
//     borderRadius: ThemeBorders.stadiumBorder,
//   ),
//   focusedBorder: const OutlineInputBorder(
//     borderSide: BorderSide(
//       color: ThemePalette.lightGrey,
//     ),
//     borderRadius: ThemeBorders.stadiumBorder,
//   ),
//   enabledBorder: const OutlineInputBorder(
//     borderSide: BorderSide(
//       color: ThemePalette.grey,
//     ),
//     borderRadius: ThemeBorders.stadiumBorder,
//   ),
//   disabledBorder: const OutlineInputBorder(
//     borderSide: BorderSide(
//       color: ThemePalette.grey,
//     ),
//     borderRadius: ThemeBorders.stadiumBorder,
//   ),
// );
}
