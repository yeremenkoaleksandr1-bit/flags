import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

class BendsStyle extends FlagStyle {
  BendsStyle({
    required super.rect,
    super.colors = const [
      Colors.white,
      Colors.black,
    ],
  }) : super(
          paths: (Rect rect) => [
            SPath(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[0],
              ),
              points: [
                SPoint.line(rect.width, 0),
                SPoint.line(0, rect.height),
              ],
              rect: rect,
            ),
            SPath(
              paint: SPaint(
                style: PaintingStyle.fill,
                color: colors[1],
              ),
              points: [
                SPoint.move(rect.width, rect.height),
                SPoint.line(0, rect.height),
                SPoint.line(rect.width, 0),
              ],
              rect: rect,
            ),
          ],
        );

  @override
  BendsStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  }) {
    return BendsStyle(
      rect: rect ?? this.rect,
      colors: colors ?? this.colors,
    );
  }
}
