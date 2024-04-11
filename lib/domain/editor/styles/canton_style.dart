import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class CantonStyle extends FlagStyle {
  CantonStyle({
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
              rect: Rect.fromLTWH(0, 0, rect.width, rect.height),
            ),
            SPath.rect(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[1],
              ),
              rect: Rect.fromLTWH(0, 0, rect.width / 2, rect.height / 2),
            ),
          ],
        );

  @override
  CantonStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    double fraction = 1,
  }) {
    return CantonStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
