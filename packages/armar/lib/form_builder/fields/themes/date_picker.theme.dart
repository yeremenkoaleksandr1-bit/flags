import 'package:flutter/material.dart';

class ArFormBuilderDatePickerTheme
    extends ThemeExtension<ArFormBuilderDatePickerTheme> {
  final InputDecoration decoration;

  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final String? helpText;

  const ArFormBuilderDatePickerTheme({
    this.decoration = const InputDecoration(
      suffixIcon: Icon(Icons.date_range),
    ),
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.helpText,
  });

  @override
  ThemeExtension<ArFormBuilderDatePickerTheme> lerp(
    covariant ThemeExtension<ArFormBuilderDatePickerTheme>? other,
    double t,
  ) {
    return this;
  }

  @override
  ThemeExtension<ArFormBuilderDatePickerTheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
