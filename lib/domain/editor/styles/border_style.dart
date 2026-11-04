import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class BorderStyle extends FlagStyle {
  BorderStyle({
    required super.rect,
    super.colors = const [
      Colors.black,
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
            SPath.rect(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[1],
              ),
              rect: () {
                const double padding = 4;

                return Rect.fromLTWH(
                  padding,
                  padding,
                  rect.width - padding * 2,
                  rect.height - padding * 2,
                );
              }.call(),
            ),
          ],
        );

  @override
  BorderStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return BorderStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
