part of '../north_america.dart';

class MexicoFlag extends GameFlag {
  MexicoFlag()
      : super(
          name: "Mexico",
          proportion: 4 / 7,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF006847),
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
              EmblemPart.fromType<MexicoEmblem>(
                position: Vector2(42, 19.31),
                size: Vector2(28, 25.38),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '3',
                position: Vector2(unitWidth * 2, 0),
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
