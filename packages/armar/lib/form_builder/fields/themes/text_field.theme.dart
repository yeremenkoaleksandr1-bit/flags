import 'package:flutter/material.dart';

class ArFormBuilderTextFieldTheme
    extends ThemeExtension<ArFormBuilderTextFieldTheme> {
  final double spaceBetweenFieldAndErrors;
  final double spaceBetweenErrors;

  final InputDecoration decoration;

  const ArFormBuilderTextFieldTheme({
    this.spaceBetweenFieldAndErrors = 4,
    this.spaceBetweenErrors = 4,
    this.decoration = const InputDecoration(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isCollapsed: true,
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
    ),
  });

  InputDecorationTheme toDecorationTheme() {
    return InputDecorationTheme(
      border: decoration.border,
      labelStyle: decoration.labelStyle,
      floatingLabelStyle: decoration.floatingLabelStyle,
      helperStyle: decoration.helperStyle,
      helperMaxLines: decoration.helperMaxLines,
      hintStyle: decoration.hintStyle,
      hintFadeDuration: decoration.hintFadeDuration,
      errorStyle: decoration.errorStyle,
      errorMaxLines: decoration.errorMaxLines,
      isDense: true,
      contentPadding: decoration.contentPadding,
      isCollapsed: true,
      iconColor: decoration.iconColor,
      prefixStyle: decoration.prefixStyle,
      prefixIconColor: decoration.prefixIconColor,
      suffixStyle: decoration.suffixStyle,
      suffixIconColor: decoration.suffixIconColor,
      counterStyle: decoration.counterStyle,
      filled: true,
      fillColor: decoration.fillColor,
      focusColor: decoration.focusColor,
      hoverColor: decoration.hoverColor,
      errorBorder: decoration.errorBorder,
      focusedBorder: decoration.focusedBorder,
      focusedErrorBorder: decoration.focusedErrorBorder,
      disabledBorder: decoration.disabledBorder,
      enabledBorder: decoration.enabledBorder,
      constraints: decoration.constraints,
    );
  }

  @override
  ThemeExtension<ArFormBuilderTextFieldTheme> copyWith({
    double? spaceBetweenFieldAndErrors,
    double? spaceBetweenErrors,
    InputDecoration? decoration,
  }) {
    return ArFormBuilderTextFieldTheme(
      spaceBetweenFieldAndErrors:
          spaceBetweenFieldAndErrors ?? this.spaceBetweenFieldAndErrors,
      spaceBetweenErrors: spaceBetweenErrors ?? this.spaceBetweenErrors,
      decoration: decoration ?? this.decoration,
    );
  }

  @override
  ThemeExtension<ArFormBuilderTextFieldTheme> lerp(
    covariant ThemeExtension<ArFormBuilderTextFieldTheme>? other,
    double t,
  ) {
    return this;
  }
}
