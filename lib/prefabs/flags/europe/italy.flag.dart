part of '../europe.dart';

class ItalyFlag extends GameFlag {
  ItalyFlag()
      : super(
          name: "Italy",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject(
              name: '1',
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF008C45),
                ),
                rect: Vector2(size.x / 3, size.y).toRect(),
              ),
            ),
            PathGameObject(
              name: "2",
              position: Vector2(size.x / 3, 0),
              path: SPath.rect(
                rect: Vector2(size.x / 3, size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFF4F5F0),
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
                  color: const Color(0xFFCD212A),
                ),
              ),
            ),
          ],
        );
}
