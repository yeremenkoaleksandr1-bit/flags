import 'package:flutter/material.dart';

class ArScreenTheme extends ThemeExtension<ArScreenTheme> {
  final EdgeInsets contentPadding;

  const ArScreenTheme({
    required this.contentPadding,
  });

  @override
  ThemeExtension<ArScreenTheme> copyWith({
    EdgeInsets? contentPadding,
  }) {
    return ArScreenTheme(
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  ThemeExtension<ArScreenTheme> lerp(
      covariant ThemeExtension<ArScreenTheme>? other, double t) {
    return this;
  }
}
