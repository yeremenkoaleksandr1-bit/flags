part of '../north_america.dart';

class SalvadorFlag extends GameFlag {
  SalvadorFlag()
      : super(
          name: "Salvador",
          proportion: 9 / 16,
          objects: (size) {
            const double totalFlex = 3;
            final double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0047AB),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFffffff),
                  ),
                ),
              ),
              EmblemPart.fromType<SalvadorEmblem>(
                position: Vector2(46.73, 22.49),
                size: Vector2(19.98, 19.01),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0047AB),
                  ),
                ),
              ),
            ];
          },
        );
}
