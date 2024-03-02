part of '../europe.dart';

class RomaniaFlag extends GameFlag {
  RomaniaFlag()
      : super(
          name: "Romania",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF002B7F),
                  ),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFCD116),
                  ),
                ),
              ),
              PathPart(
                name: "3",
                position: Vector2((unitWidth) * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
                  ),
                ),
              ),
            ];
          },
        );
}
