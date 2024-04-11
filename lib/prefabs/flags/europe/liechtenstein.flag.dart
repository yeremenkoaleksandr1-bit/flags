part of '../europe.dart';

class LiechtensteinFlag extends GameFlag {
  LiechtensteinFlag()
      : super(
          name: "Liechtenstein",
          proportion: 3 / 5,
          objects: (size) {
            double totalFlex = 2;
            double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF002780),
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
                    color: const Color(0xFFCF0921),
                  ),
                ),
              ),
              EmblemPart.fromType<LiechtensteinEmblem>(
                position: Vector2(12.79, 5.67),
                size: Vector2(21.76, 18.95),
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
