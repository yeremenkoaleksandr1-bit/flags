part of '../africa.dart';

class SudanFlag extends GameFlag {
  SudanFlag()
      : super(
          name: "Sudan",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD21034),
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
              PathGameObject(
                name: '3',
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject.fromSvgPath(
                "m0 0 42.667 32L0 64V0Z",
                name: '4',
                color: const Color(0xff007229),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
