part of '../africa.dart';

class NigeriaFlag extends GameFlag {
  NigeriaFlag()
      : super(
          name: "Nigeria",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 3;
            final double unitWidth = size.x / totalFlex;
            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF008751),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathGameObject(
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
              PathGameObject(
                name: "1",
                uniqueName: "1_2",
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
