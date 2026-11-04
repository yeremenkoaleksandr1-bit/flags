import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/parts/cross.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class GreekCrossStyle extends FlagStyle {
  GreekCrossStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.black,
    ],
  }) : super(
          paths: (Rect rect) => [
            SPath.rect(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[0],
              ),
              rect: rect,
            ),
            CrossPart(
              paint: SPaint(
                style: PaintingStyle.stroke,
                color: colors[1],
                strokeWidth: 8,
              ),
              rect: rect,
              width: 24,
              height: 24,
            ),
          ],
        );

  @override
  GreekCrossStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return GreekCrossStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
