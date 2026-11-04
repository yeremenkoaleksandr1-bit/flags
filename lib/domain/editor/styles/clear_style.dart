import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class ClearStyle extends FlagStyle {
  ClearStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
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
          ],
        );

  @override
  ClearStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return ClearStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
