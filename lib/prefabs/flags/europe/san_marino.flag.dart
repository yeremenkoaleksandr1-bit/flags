part of '../europe.dart';

class SanMarinoFlag extends GameFlag {
  SanMarinoFlag()
      : super(
          name: "San Marino",
          proportion: 3 / 4,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFFFFF),
                ),
                rect: Vector2(size.x, size.y / 2).toRect(),
              ),
            ),
            PathPart(
              name: "2",
              position: Vector2(0, size.y / 2),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF5EB6E4),
                ),
                rect: Vector2(size.x, size.y / 2).toRect(),
              ),
            ),
            EmblemPart.fromType<SanMarinoEmblem>(
              position: Vector2(26.66, 9.36),
              size: Vector2(32.01, 38.48),
              previousMustBePlaced: const ['1', '2'],
            ),
          ],
        );
}
