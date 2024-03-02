part of '../asia.dart';

class SingaporeFlag extends GameFlag {
  SingaporeFlag()
      : super(
          name: "Singapore",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFED2939),
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
                  color: const Color(0xFFffffff),
                ),
              ),
            ),
            EmblemPart.fromType<SingaporeEmblem>(
              position: Vector2(8.5, 4.22),
              size: Vector2(28.47, 24.5),
              previousMustBePlaced: const ['1', '2'],
            ),
          ],
        );
}
