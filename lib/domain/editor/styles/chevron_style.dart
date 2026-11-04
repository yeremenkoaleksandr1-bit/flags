import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class ChevronStyle extends FlagStyle {
  ChevronStyle({
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
            SPath(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[1],
              ),
              points: [
                SPoint.move(0, 0),
                SPoint.line(
                  rect.width * 0.5,
                  rect.height / 2,
                ),
                SPoint.line(
                  0,
                  rect.height,
                ),
              ],
              rect: rect,
            ),
          ],
        );

  @override
  ChevronStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    double fraction = 1,
  }) {
    return ChevronStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
