part of '../europe.dart';

class GermanyFlag extends GameFlag {
  GermanyFlag()
      : super(
          name: "Germany",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 3).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            PathGameObject(
              name: "2",
              position: Vector2(0, size.y / 3),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFF0000),
                ),
                rect: Vector2(size.x, size.y / 3).toRect(),
              ),
            ),
            PathGameObject(
              name: "3",
              position: Vector2(0, size.y / 3 * 2),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFCC00),
                ),
                rect: Vector2(size.x, size.y / 3).toRect(),
              ),
            ),
          ],
        );
}
