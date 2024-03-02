part of '../south_america.dart';

class ParaguayFlag extends GameFlag {
  ParaguayFlag()
      : super(
          name: "Paraguay",
          proportion: 11 / 20,
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
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<ParaguayEmblem>(
                position: Vector2(50.07, 23.89),
                size: Vector2(16.22, 16.22),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: '3',
                position: Vector2(0, unit * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0038A8),
                  ),
                ),
              ),
            ];
          },
        );
}
