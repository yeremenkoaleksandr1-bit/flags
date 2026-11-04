part of '../europe.dart';

class AlbaniaFlag extends GameFlag {
  AlbaniaFlag()
      : super(
          name: "Albania",
          proportion: 5 / 7,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFF0000),
                ),
                rect: size.toRect(),
              ),
            ),
            EmblemPart.fromType<AlbaniaEmblem>(
              position: Vector2(26, 12),
              size: Vector2(36, 40),
              previousMustBePlaced: ['1'],
            ),
          ],
        );
}
