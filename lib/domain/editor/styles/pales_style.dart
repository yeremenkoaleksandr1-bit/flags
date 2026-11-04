import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class PalesStyle extends FlagStyle {
  PalesStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.black,
      Colors.white,
    ],
  }) : super(
          paths: (Rect rect) {
            final width = rect.width / 3;

            return [
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[0],
                ),
                rect: Rect.fromLTWH(0, 0, width, rect.height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[1],
                ),
                rect: Rect.fromLTWH(width, 0, width, rect.height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[2],
                ),
                rect: Rect.fromLTWH(width * 2, 0, width, rect.height),
              ),
            ];
          },
        );

  @override
  PalesStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return PalesStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
