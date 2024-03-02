part of '../north_america.dart';

class GuatemalaFlag extends GameFlag {
  GuatemalaFlag()
      : super(
          name: "Guatemala",
          proportion: 5 / 8,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF4997D0),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathPart(
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
              PathPart(
                name: '1',
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
