part of '../europe.dart';

class BelarusFlag extends GameFlag {
  BelarusFlag()
      : super(
          name: "Belarus",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart(
              name: '1',
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFCE1720),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M0 0h113v21H0V0Z",
              name: '2',
              areaSize: size,
              position: (bounds) => Vector2(
                size.x - bounds.width,
                size.y - bounds.height,
              ),
              color: const Color(0xFF007C30),
            ),
            EmblemPart.fromType<BelarusEmblem>(
              position: Vector2(1, 0),
              size: Vector2(14, 64),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
