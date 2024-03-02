import 'package:flutter/material.dart';

class ArScrollableViewTheme extends ThemeExtension<ArScrollableViewTheme> {
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Color? thumbColor;
  final Color? trackColor;
  final Color? trackBorderColor;
  final Radius? trackRadius;
  final Radius? radius;

  const ArScrollableViewTheme({
    this.padding,
    this.physics,
    this.thumbColor,
    this.trackColor,
    this.trackBorderColor,
    this.trackRadius,
    this.radius,
  });

  @override
  ThemeExtension<ArScrollableViewTheme> copyWith({
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Color? thumbColor,
    Color? trackColor,
    Color? trackBorderColor,
    Radius? trackRadius,
    Radius? radius,
  }) {
    return ArScrollableViewTheme(
      padding: padding,
      physics: physics,
      thumbColor: thumbColor,
      trackColor: trackColor,
      trackBorderColor: trackBorderColor,
      trackRadius: trackRadius,
      radius: radius,
    );
  }

  @override
  ThemeExtension<ArScrollableViewTheme> lerp(
      covariant ThemeExtension<ArScrollableViewTheme>? other, double t) {
    return this;
  }
}
