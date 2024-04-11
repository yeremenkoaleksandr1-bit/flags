part of '../europe.dart';

class SlovakiaFlag extends GameFlag {
  SlovakiaFlag()
      : super(
          name: "Slovakia",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0B4EA2),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFEE1C25),
                  ),
                ),
              ),
              EmblemPart.fromType<SlovakiaEmblem>(
                position: Vector2(15.52, 15.52),
                size: Vector2(26.56, 33.01),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
