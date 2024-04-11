import 'package:armar/armar.dart';
import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flutter/material.dart';

class FessesStyle extends FlagStyle {
  final List<int> ratios;

  FessesStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.black,
      Colors.white,
    ],
    this.ratios = const [1, 1, 1],
  }) : super(
          paths: (Rect rect) {
            final height = rect.height;
            final total = ratios.sum;

            return [
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[0],
                ),
                rect: Rect.fromLTWH(
                  0,
                  0,
                  rect.width,
                  height * (ratios[0] / total),
                ),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[1],
                ),
                rect: Rect.fromLTWH(
                  0,
                  height * (ratios[0] / total),
                  rect.width,
                  height * (ratios[1] / total),
                ),
              ),
              SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[2],
                ),
                rect: Rect.fromLTWH(
                  0,
                  height * (ratios[1] / total) + height * (ratios[0] / total),
                  rect.width,
                  height * (ratios[2] / total),
                ),
              ),
            ];
          },
        );

  @override
  FessesStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    List<int>? ratios,
  }) {
    return FessesStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
      ratios: ratios ?? this.ratios,
    );
  }
}
