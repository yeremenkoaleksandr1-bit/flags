import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class SaltireStyle extends FlagStyle {
  SaltireStyle({
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
                SPoint.line(rect.width, rect.height),
                SPoint.move(0, rect.height),
                SPoint.line(rect.width, 0),
              ],
              rect: rect,
            ),
          ],
        );

  @override
  SaltireStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return SaltireStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
