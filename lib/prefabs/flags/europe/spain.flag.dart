part of '../europe.dart';

class SpainFlag extends GameFlag {
  SpainFlag()
      : super(
          name: "Spain",
          proportion: 2 / 3,
          objects: (size) {
            final double totalFlex = 4;
            final double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFAD1519),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight * 2).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFABD00),
                  ),
                ),
              ),
              PathGameObject(
                name: "1",
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFAD1519),
                  ),
                ),
              ),
              EmblemPart.fromType<SpainEmblem>(
                position: Vector2(20.29, 19.22),
                size: Vector2(23.42, 25.53),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
