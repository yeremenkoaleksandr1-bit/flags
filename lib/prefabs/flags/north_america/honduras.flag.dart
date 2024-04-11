part of '../north_america.dart';

class HondurasFlag extends GameFlag {
  HondurasFlag()
      : super(
          name: "Honduras",
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
                    color: const Color(0xFF00BCE4),
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
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                'm3.382 0 .798 2.457h2.583l-2.09 1.518.798 2.457-2.09-1.518-2.09 1.518.799-2.457L0 2.457h2.583L3.382 0Zm0 10.667.798 2.457h2.583l-2.09 1.518.798 2.457-2.09-1.519-2.09 1.519.799-2.457L0 13.124h2.583l.799-2.457ZM21.958 7.79l-.799-2.457-.798 2.457h-2.583l2.09 1.519-.799 2.456 2.09-1.518 2.09 1.518-.798-2.456 2.09-1.519h-2.583ZM38.937 0l.798 2.457h2.584l-2.09 1.518.798 2.457-2.09-1.518-2.09 1.518.798-2.457-2.09-1.518h2.584L38.937 0Zm.798 13.124-.798-2.457-.798 2.457h-2.584l2.09 1.518-.798 2.457 2.09-1.519 2.09 1.519-.798-2.457 2.09-1.518h-2.584Z',
                name: '3',
                color: const Color(0xFF00BCE4),
                areaSize: size,
                position: (_) => Vector2(42.84, 23.11),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                position: Vector2(0, unitFlex * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00BCE4),
                  ),
                ),
              ),
            ];
          },
        );
}
