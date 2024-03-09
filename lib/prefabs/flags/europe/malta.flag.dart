part of '../europe.dart';

class MaltaFlag extends GameFlag {
  MaltaFlag()
      : super(
          name: "Malta",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFFFFF),
                ),
                rect: Vector2(size.x / 2, size.y).toRect(),
              ),
            ),
            PathPart(
              name: "2",
              position: Vector2(size.x / 2, 0),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFCF142B),
                ),
                rect: Vector2(size.x / 2, size.y).toRect(),
              ),
            ),
            EmblemPart.fromType<MaltaEmblem>(
              position: Vector2.all(2),
              size: Vector2.all(18),
              previousMustBePlaced: const ['1'],
            )
          ],
        );
}
