part of '../asia.dart';

class IndonesiaFlag extends GameFlag {
  IndonesiaFlag()
      : super(
          name: "Indonesia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFF0000),
                ),
              ),
            ),
            PathPart(
              name: "2",
              position: Vector2(0, size.y / 2),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        );
}
