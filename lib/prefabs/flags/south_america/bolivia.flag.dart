part of '../south_america.dart';

class BoliviaFlag extends GameFlag {
  BoliviaFlag()
      : super(
          name: "Bolivia",
          proportion: 15 / 22,
          objects: (size) {
            double totalFlex = 3;
            double unit = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD52B1E),
                  ),
                  rect: Vector2(size.x, unit).toRect(),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(0, unit),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFF9E300),
                  ),
                ),
              ),
              EmblemPart.fromType<BoliviaEmblem>(
                position: Vector2(36.27, 22.73),
                size: Vector2(21.32, 18.51),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: '3',
                position: Vector2(0, unit * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF007934),
                  ),
                ),
              ),
            ];
          },
        );
}
