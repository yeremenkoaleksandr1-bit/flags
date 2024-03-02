part of '../europe.dart';

class SpainFlag extends GameFlag {
  SpainFlag()
      : super(
          name: "Spain",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 4;
            double unitHeight = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFAD1519),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathPart(
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
              PathPart(
                name: "3",
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
                previousMustBePlaced: ['1', '2', '3'],
              ),
            ];
          },
        );
}
