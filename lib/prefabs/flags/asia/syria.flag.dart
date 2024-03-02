part of '../asia.dart';

class SyriaFlag extends GameFlag {
  SyriaFlag()
      : super(
          name: "Syria",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
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
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathPart(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "M5.586 10.079 3.6 16.19l5.199-3.777 5.198 3.777-1.985-6.111 5.198-3.777h-6.426L8.8.19 6.813 6.302H.387l5.199 3.777Z",
                name: '4',
                color: const Color(0xff007A3D),
                areaSize: size,
                previousMustBePlaced: const ['2'],
                position: (_) => Vector2(55.59, 24),
              ),
              PathPart.fromSvgPath(
                "M5.586 10.079 3.6 16.19l5.199-3.777 5.198 3.777-1.985-6.111 5.198-3.777h-6.426L8.8.19 6.813 6.302H.387l5.199 3.777Z",
                name: '4',
                color: const Color(0xff007A3D),
                areaSize: size,
                previousMustBePlaced: const ['2'],
                position: (_) => Vector2(23.59, 24),
              ),
            ];
          },
        );
}
