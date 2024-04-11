part of '../africa.dart';

class GabonFlag extends GameFlag {
  GabonFlag()
      : super(
          name: "Gabon",
          proportion: 3 / 4,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF009E60),
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
                    color: const Color(0xFFFCD116),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF3A75C4),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
            ];
          },
        );
}
