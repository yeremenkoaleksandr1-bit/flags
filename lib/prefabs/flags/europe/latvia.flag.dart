part of '../europe.dart';

class LatviaFlag extends GameFlag {
  LatviaFlag()
      : super(
          name: "Latvia",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 5;
            final double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight * 2).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF9E3039),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathGameObject(
                name: "1",
                uniqueName: "1_2",
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight * 2).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF9E3039),
                  ),
                ),
              ),
            ];
          },
        );
}
