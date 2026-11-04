part of '../africa.dart';

class SierraLeoneFlag extends GameFlag {
  SierraLeoneFlag()
      : super(
          name: "Sierra leone",
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
                    color: const Color(0xFF1EB53A),
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
                    color: const Color(0xFF0072C6),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
            ];
          },
        );
}
