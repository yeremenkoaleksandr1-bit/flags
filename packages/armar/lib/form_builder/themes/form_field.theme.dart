import 'package:flutter/material.dart';

@immutable
class ArLabelFieldTheme extends ThemeExtension<ArLabelFieldTheme> {
  const ArLabelFieldTheme({
    this.labelStyle = const TextStyle(),
    this.spaceBetween = 4,
  });

  final double spaceBetween;
  final TextStyle labelStyle;

  @override
  ArLabelFieldTheme copyWith({
    TextStyle? labelStyle,
    double? spaceBetween,
  }) {
    return ArLabelFieldTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      spaceBetween: spaceBetween ?? this.spaceBetween,
    );
  }

  @override
  ArLabelFieldTheme lerp(
    covariant ThemeExtension<ArLabelFieldTheme>? other,
    double t,
  ) {
    return this;
  }
}
