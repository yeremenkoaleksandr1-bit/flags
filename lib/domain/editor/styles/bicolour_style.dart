import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class BicolourStyle extends FlagStyle {
  BicolourStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.black,
    ],
  }) : super(
          paths: (Rect rect) {
            final height = rect.height / 2;

            return [
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[0],
                ),
                rect: Offset.zero & Size(rect.width, height),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[1],
                ),
                rect: Rect.fromLTWH(0, height, rect.width, height),
              ),
            ];
          },
        );

  @override
  BicolourStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return BicolourStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
