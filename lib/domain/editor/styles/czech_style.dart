import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class CzechStyle extends FlagStyle {
  CzechStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.grey,
      Color(0xff444444),
    ],
  }) : super(
          paths: (Rect rect) {
            return [
              SPath(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[0],
                ),
                points: [
                  SPoint.move(0, 0),
                  SPoint.line(rect.width, 0),
                  SPoint.line(rect.width, rect.height / 2),
                  SPoint.line(rect.width / 2, rect.height / 2),
                  SPoint.line(0, 0),
                ],
                rect: rect,
              ),
              SPath(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[1],
                ),
                points: [
                  SPoint.move(0, rect.height),
                  SPoint.line(rect.width, rect.height),
                  SPoint.line(rect.width, rect.height / 2),
                  SPoint.line(rect.width / 2, rect.height / 2),
                  SPoint.line(0, rect.height),
                ],
                rect: rect,
              ),
              SPath(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: colors[2],
                ),
                points: [
                  SPoint.line(rect.centerX, rect.centerY),
                  SPoint.line(0, rect.height),
                  SPoint.line(0, 0),
                ],
                rect: rect,
              ),
            ];
          },
        );

  @override
  CzechStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return CzechStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
