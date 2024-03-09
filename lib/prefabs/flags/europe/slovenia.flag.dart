part of '../europe.dart';

class SloveniaFlag extends GameFlag {
  SloveniaFlag()
      : super(
          name: "Slovenia",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFffffff),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0000FF),
                  ),
                ),
              ),
              PathPart(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFF0000),
                  ),
                ),
              ),
              EmblemPart.fromType<SloveniaEmblem>(
                position: Vector2(23.65, 10.67),
                size: Vector2(16.7, 21.33),
                previousMustBePlaced: const ['1', '2'],
              ),
            ];
          },
        );
}
