part of '../north_america.dart';

class HaitiFlag extends GameFlag {
  HaitiFlag()
      : super(
          name: "Haiti",
          proportion: 3 / 5,
          objects: (size) {
            double totalFlex = 2;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00209F),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD21034),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "M0 0h20.23v16.528H0V0Z",
                name: '3',
                color: const Color(0xFFFFFFFF),
                areaSize: size,
                position: (_) => Vector2(43.22, 23.72),
                previousMustBePlaced: const ['1', '2'],
              ),
              EmblemPart.fromType<HaitiEmblem>(
                position: Vector2(43.22, 24.16),
                size: Vector2(20.23, 16.09),
                previousMustBePlaced: const ['3'],
              ),
            ];
          },
        );
}
