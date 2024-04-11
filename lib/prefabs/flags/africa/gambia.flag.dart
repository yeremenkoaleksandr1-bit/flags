part of '../africa.dart';

class GambiaFlag extends GameFlag {
  GambiaFlag()
      : super(
          name: "Gambia",
          proportion: 2 / 3,
          objects: (size) {
            const double totalFlex = 3;
            final double unitHeight = size.y / totalFlex;
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
                    color: const Color(0xFF3A7728),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
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
