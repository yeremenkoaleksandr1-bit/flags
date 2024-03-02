part of '../north_america.dart';

class BahamasFlag extends GameFlag {
  BahamasFlag()
      : super(
          name: "Bahamas",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitFlex = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00778B),
                  ),
                  rect: Vector2(size.x, unitFlex).toRect(),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(0, unitFlex),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFC72C),
                  ),
                ),
              ),
              PathPart(
                name: '1',
                position: Vector2(0, unitFlex * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00778B),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "M55.426 32 0 64V0l55.426 32Z",
                name: '3',
                color: const Color(0xFF000000),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2'],
              ),
            ];
          },
        );
}
