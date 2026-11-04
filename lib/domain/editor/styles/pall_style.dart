import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class PallStyle extends FlagStyle {
  PallStyle({
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
                style: PaintingStyle.stroke,
                color: colors[1],
                strokeWidth: 8,
              ),
              points: [
                SPoint.line(rect.width / 2.1, rect.centerY),
                SPoint.line(rect.width, rect.centerY),
                SPoint.move(0, rect.height),
                SPoint.line(rect.width / 2.1, rect.centerY),
              ],
              rect: rect,
            ),
          ],
        );

  @override
  PallStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    double fraction = 1,
  }) {
    return PallStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
