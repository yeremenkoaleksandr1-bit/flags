part of '../asia.dart';

class PalestineFlag extends GameFlag {
  PalestineFlag()
      : super(
          name: "Palestine",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            final triangle = parseSvgPathModel(
                'M0 32C0 .563 0 0 .281 0c.163 0 .312.06.341.119.03.059 9.496 7.2 21.037 15.851 11.556 8.652 21.008 15.793 21.008 15.882 0 .089-9.452 7.23-20.993 15.866C10.118 56.37.563 63.57.414 63.718.282 63.881.135 64 .09 64 .044 64 0 49.6 0 32Z');

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
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
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF009639),
                  ),
                ),
              ),
              GroupedPathsPart(
                name: 'triangle_palestine',
                position: Vector2.zero(),
                size: Vector2(64, 32),
                previousMustBePlaced: const ['1', '2', '3'],
                objects: (visualSize) => [
                  PathGameObject(
                    name: '4',
                    position: Vector2(0, 0),
                    path: triangle.copyWith(
                      paint: SPaint(
                        color: const Color(0xffED2E38),
                      ),
                    ),
                  ),
                  PathGameObject(
                    name: '4',
                    position: Vector2(0, 0),
                    path: triangle.copyWith(
                      paint: SPaint(
                        style: PaintingStyle.stroke,
                        strokeWidth: 0.6,
                        color: const Color(0xffFF0000),
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
        );
}
