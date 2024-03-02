part of '../north_america.dart';

class BarbadosFlag extends GameFlag {
  BarbadosFlag()
      : super(
          name: "Barbados",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00267F),
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
                    color: const Color(0xFFFFC726),
                  ),
                ),
              ),
              EmblemPart.fromType<BarbadosEmblem>(
                position: Vector2(34.28, 16.5),
                size: Vector2(27.44, 31.01),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: '1',
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00267F),
                  ),
                ),
              ),
            ];
          },
        );
}
