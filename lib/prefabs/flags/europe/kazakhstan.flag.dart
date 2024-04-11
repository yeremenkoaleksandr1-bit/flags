part of '../europe.dart';

class KazakhstanFlag extends GameFlag {
  KazakhstanFlag()
      : super(
          name: "Kazakhstan",
          proportion: 1 / 2,
          objects: (size) {
            return [
              PathGameObject(
                name: "1",
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00ABC2),
                  ),
                ),
              ),
              EmblemPart.fromType<KazakhstanEmblem>(
                position: Vector2(49.17, 13.43),
                size: Vector2(39.92, 35.83),
                previousMustBePlaced: ['1'],
              ),
              EmblemPart.fromType<KazakhstanPattern>(
                position: Vector2(3.84, 3.52),
                size: Vector2(7.68, 56.96),
                previousMustBePlaced: ['1'],
              ),
            ];
          },
        );
}
