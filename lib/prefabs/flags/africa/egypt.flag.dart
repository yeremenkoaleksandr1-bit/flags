part of '../africa.dart';

class EgyptFlag extends GameFlag {
  EgyptFlag()
      : super(
          name: "Egypt",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFffffff),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              EmblemPart.fromType<EgyptEmblem>(
                position: Vector2(40.61, 21.93),
                size: Vector2(14.78, 20.08),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
