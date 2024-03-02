part of '../europe.dart';

class LatviaFlag extends GameFlag {
  LatviaFlag()
      : super(
          name: "Latvia",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 5;
            double unitHeight = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight * 2).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF9E3039),
                  ),
                ),
              ),
              PathPart(
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
              PathPart(
                name: "1",
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
