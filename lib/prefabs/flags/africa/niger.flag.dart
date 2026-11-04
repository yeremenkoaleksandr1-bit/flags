part of '../africa.dart';

class NigerFlag extends GameFlag {
  NigerFlag()
      : super(
          name: "Niger",
          proportion: 6 / 7,
          objects: (size) {
            final double totalFlex = 3;
            final double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFE05206),
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
              PathGameObject.fromSvgPath(
                "M9.333 19.067a9.067 9.067 0 1 0 0-18.134 9.067 9.067 0 0 0 0 18.134Z",
                name: '4',
                color: const Color(0xffE05206),
                areaSize: size,
                position: (_) => Vector2(28, 22),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '3',
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0DB02B),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
            ];
          },
        );
}
