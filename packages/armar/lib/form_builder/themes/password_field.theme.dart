import 'package:flutter/material.dart';

class ArPasswordFieldTheme extends ThemeExtension<ArPasswordFieldTheme> {
  final IconData showedPasswordIcon;
  final IconData hiddenPasswordIcon;
  final double iconSize;
  final Color iconColor;

  const ArPasswordFieldTheme({
    this.showedPasswordIcon = Icons.visibility,
    this.hiddenPasswordIcon = Icons.visibility_off,
    this.iconColor = Colors.black,
    this.iconSize = 24,
  });

  @override
  ThemeExtension<ArPasswordFieldTheme> lerp(
    covariant ThemeExtension<ArPasswordFieldTheme>? other,
    double t,
  ) {
    return this;
  }

  @override
  ThemeExtension<ArPasswordFieldTheme> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
