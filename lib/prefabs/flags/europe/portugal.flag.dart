part of '../europe.dart';

class PortugalFlag extends GameFlag {
  PortugalFlag()
      : super(
          name: "Portugal",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x / ((64 / (2 / 3)) / 38), size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF006600),
                ),
              ),
            ),
            PathPart(
              name: "2",
              position: Vector2(size.x / ((64 / (2 / 3)) / 38), 0),
              path: SPath.rect(
                rect: Vector2(size.x / ((64 / (2 / 3)) / 58), size.y).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFF0000),
                ),
              ),
            ),
            EmblemPart.fromType<PortugalEmblem>(
                position: Vector2(22, 16),
                size: Vector2.all(32),
                previousMustBePlaced: const ['1', '2'])
          ],
        );
}
