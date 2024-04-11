import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/points.dart';
import 'package:flutter/material.dart';

class SymmetricCrossStyle extends FlagStyle {
  SymmetricCrossStyle({
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
                SPoint.move(rect.centerX, 0),
                SPoint.line(rect.centerX, rect.height),
                SPoint.move(0, rect.centerY),
                SPoint.line(rect.width, rect.centerY),
              ],
            ),
          ],
        );

  @override
  SymmetricCrossStyle copyWith({
    Rect? rect,
    List<Color>? colors,
    double fraction = 1,
  }) {
    return SymmetricCrossStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
