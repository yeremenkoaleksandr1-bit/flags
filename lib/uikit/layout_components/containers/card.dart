import 'package:flags/uikit/theme/indents.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FCard extends StatelessWidget {
  const FCard({
    super.key,
    required this.child,
    this.color = ThemePalette.peachCard,
    this.padding,
  });

  final Widget child;

  final Color color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.darken(0.6),
          width: 2.r,
          strokeAlign: -0.98,
        ),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(ThemeIndents.s8),
        child: child,
      ),
    );
  }
}
