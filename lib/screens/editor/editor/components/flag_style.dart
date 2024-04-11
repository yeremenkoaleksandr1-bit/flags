import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flutter/material.dart';

class FlagStyleView extends StatelessWidget {
  const FlagStyleView({
    super.key,
    required this.style,
  });

  final FlagStyle style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return FittedBox(
          child: SizedBox.fromSize(
            size: style.rect.size,
            child: ClipRRect(
              child: DrawablePaint(
                size: constraints.biggest,
                drawable: style,
              ),
            ),
          ),
        );
      },
    );
  }
}
