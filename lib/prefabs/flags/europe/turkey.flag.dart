part of '../europe.dart';

class TurkeyFlag extends GameFlag {
  TurkeyFlag()
      : super(
          name: "Turkey",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFE30A17),
                ),
              ),
            ),
            EmblemPart.fromType<TurkeyEmblem>(
              position: Vector2(16, 16),
              size: Vector2(43, 32),
              previousMustBePlaced: const ['1'],
            )
          ],
        );
}
