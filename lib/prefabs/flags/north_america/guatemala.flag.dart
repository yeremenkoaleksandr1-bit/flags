part of '../north_america.dart';

class GuatemalaFlag extends GameFlag {
  GuatemalaFlag()
      : super(
          name: "Guatemala",
          proportion: 5 / 8,
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
                    color: const Color(0xFF4997D0),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<GuatemalaEmblem>(
                position: Vector2(39.83, 22.09),
                size: Vector2(22.74, 19.83),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF4997D0),
                  ),
                ),
              ),
            ];
          },
        );
}
