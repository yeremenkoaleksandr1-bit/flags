part of '../africa.dart';

class AlgeriaFlag extends GameFlag {
  AlgeriaFlag()
      : super(
          name: "Algeria",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 2;
            double unitWidth = size.x / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF006633),
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
              EmblemPart.fromType<AlgeriaEmblem>(
                position: Vector2(32, 16),
                size: Vector2(30.47, 32),
                previousMustBePlaced: const ['1', '2'],
              ),
            ];
          },
        );
}
