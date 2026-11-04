import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class ScandinavianCrossStyle extends FlagStyle {
  ScandinavianCrossStyle({
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
              rect: rect,
              paint: SPaint(
                style: PaintingStyle.stroke,
                color: colors[1],
                strokeWidth: 8,
              ),
              points: [
                SPoint.move(rect.centerX / 1.3, 0),
                SPoint.line(rect.centerX / 1.3, rect.height),
                SPoint.move(0, rect.centerY),
                SPoint.line(rect.width, rect.centerY),
              ],
            ),
          ],
        );

  @override
  ScandinavianCrossStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return ScandinavianCrossStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
