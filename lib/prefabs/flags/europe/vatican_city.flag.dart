part of '../europe.dart';

class VaticanCityFlag extends GameFlag {
  VaticanCityFlag()
      : super(
          name: "Vatican city",
          proportion: 1 / 1,
          objects: (size) {
            double totalFlex = 2;
            double unitWidth = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFE000),
                  ),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<VaticanCityEmblem>(
                position: Vector2(37, 13),
                size: Vector2(22, 34),
                previousMustBePlaced: const ['2'],
              )
            ];
          },
        );
}
