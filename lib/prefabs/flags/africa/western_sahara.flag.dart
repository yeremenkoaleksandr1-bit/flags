part of '../africa.dart';

class WesternSaharaFlag extends GameFlag {
  WesternSaharaFlag()
      : super(
          name: "Western sahara",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFffffff),
                  ),
                ),
              ),
              EmblemPart.fromType<SahrawiArabDemocraticRepublicEmblem>(
                position: Vector2(55.47, 23),
                size: Vector2(15.77, 17.07),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF007A3D),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "m0 0 42.667 32L0 64V0Z",
                name: '4',
                color: const Color(0xffC4111B),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
