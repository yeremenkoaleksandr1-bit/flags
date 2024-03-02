part of '../europe.dart';

class MonacoFlag extends GameFlag {
  MonacoFlag()
      : super(
          name: "Monaco",
          proportion: 4 / 5,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFd00820),
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
