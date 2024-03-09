part of '../africa.dart';

class GambiaFlag extends GameFlag {
  GambiaFlag()
      : super(
          name: "Gambia",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
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
                    color: const Color(0xFFffffff),
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
                    color: const Color(0xFF3A7728),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "M0 0h96v14.222H0V0Z",
                name: '4',
                color: const Color(0xff0C1C8C),
                areaSize: size,
                position: (_) => Vector2(0, 25),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
