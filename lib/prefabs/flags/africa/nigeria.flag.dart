part of '../africa.dart';

class NigeriaFlag extends GameFlag {
  NigeriaFlag()
      : super(
          name: "Nigeria",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF008751),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFffffff),
                  ),
                ),
              ),
              PathPart(
                name: "1",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF008751),
                  ),
                ),
              ),
            ];
          },
        );
}
