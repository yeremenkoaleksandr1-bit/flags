part of '../south_america.dart';

class PeruFlag extends GameFlag {
  PeruFlag()
      : super(
          name: "Peru",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unit = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD91023),
                  ),
                  rect: Vector2(unit, size.y).toRect(),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(unit, 0),
                path: SPath.rect(
                  rect: Vector2(unit, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<PeruEmblem>(
                position: Vector2(34.65, 19.12),
                size: Vector2(26.7, 25.79),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: '1',
                position: Vector2(unit * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unit, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD91023),
                  ),
                ),
              ),
            ];
          },
        );
}
