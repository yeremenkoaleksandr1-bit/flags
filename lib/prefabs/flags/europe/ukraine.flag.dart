part of '../europe.dart';

class UkraineFlag extends GameFlag {
  UkraineFlag()
      : super(
          name: "Ukraine",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart(
              name: "part_1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF0057b7),
                ),
              ),
            ),
            PathPart(
              name: "part_2",
              position: Vector2(0, size.y / 2),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFffd700),
                ),
              ),
            ),
          ],
        );
}
