part of '../europe.dart';

class BelgiumFlag extends GameFlag {
  BelgiumFlag()
      : super(
          name: "Belgium",
          proportion: 13 / 15,
          objects: (size) => [
            PathGameObject(
              name: '1',
              path: SPath.rect(
                rect: Vector2(size.x / 3, size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            PathGameObject(
              name: "2",
              position: Vector2(size.x / 3, 0),
              path: SPath.rect(
                rect: Vector2(size.x / 3, size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFDDA24),
                ),
              ),
            ),
            PathGameObject(
              name: "3",
              position: Vector2((size.x / 3) * 2, 0),
              path: SPath.rect(
                rect: Vector2(size.x / 3, size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFEF3340),
                ),
              ),
            ),
          ],
        );
}
