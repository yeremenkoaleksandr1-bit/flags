part of '../asia.dart';

class MongoliaFlag extends GameFlag {
  MongoliaFlag()
      : super(
          name: "Mongolia",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 3;
            final double unitWidth = size.x / totalFlex;

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFDA2031),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0066B2),
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
                    color: const Color(0xFFDA2031),
                  ),
                ),
              ),
              EmblemPart.fromType<MongoliaEmblem>(
                position: Vector2(9.6, 6.4),
                size: Vector2(23.47, 48),
                previousMustBePlaced: const ['1_1'],
              ),
            ];
          },
        );
}
