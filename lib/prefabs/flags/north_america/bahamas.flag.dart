part of '../north_america.dart';

class BahamasFlag extends GameFlag {
  BahamasFlag()
      : super(
          name: "Bahamas",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 3;
            final double unitFlex = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00778B),
                  ),
                  rect: Vector2(size.x, unitFlex).toRect(),
                ),
              ),
              PathGameObject(
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
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                position: Vector2(0, unitFlex * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00778B),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
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
