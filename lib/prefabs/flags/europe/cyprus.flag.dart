part of '../europe.dart';

class CyprusFlag extends GameFlag {
  CyprusFlag()
      : super(
          name: "Cyprus",
          proportion: 2 / 3,
          objects: (size) {
            return [
              PathGameObject(
                name: "1",
                position: Vector2.zero(),
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<CyprusEmblem>(
                position: Vector2(25.13, 11.09),
                size: Vector2(52.46, 42.97),
                previousMustBePlaced: ['1'],
              ),
            ];
          },
        );
}
