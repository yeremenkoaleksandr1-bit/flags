import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/theme/borders.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class FCard extends StatelessWidget {
  const FCard({
    super.key,
    required this.child,
    this.color = ThemePalette.peachCard,
    this.padding = const Pad(all: ThemeIndents.s8),
  });

  final Widget child;

  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.darken(0.6),
          width: 2,
          strokeAlign: -0.98,
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
