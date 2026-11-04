import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class QuarterlyStyle extends FlagStyle {
  QuarterlyStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Color(0xff777777),
      Color(0xff444444),
      Colors.black,
    ],
  }) : super(
          paths: (Rect rect) {
            final height = rect.height / 2;
            final width = rect.width / 2;

            return [
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[0],
                ),
                rect: Rect.fromLTWH(0, 0, width, height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[1],
                ),
                rect: Rect.fromLTWH(width, 0, width, height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[2],
                ),
                rect: Rect.fromLTWH(0, height, width, height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[3],
                ),
                rect: Rect.fromLTWH(width, height, width, height),
              ),
            ];
          },
        );

  @override
  QuarterlyStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    double fraction = 1,
  }) {
    return QuarterlyStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
