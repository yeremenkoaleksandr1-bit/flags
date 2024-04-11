part of '../africa.dart';

class UgandaFlag extends GameFlag {
  UgandaFlag()
      : super(
          name: "Uganda",
          proportion: 2 / 3,
          objects: (size) {
            const double totalFlex = 6;
            final double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_1",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFCDC04),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                uniqueName: '0_1',
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD90000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: '1',
                uniqueName: '0_2',
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_2",
                position: Vector2(0, unitHeight * 4),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFCDC04),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                uniqueName: "3_1",
                position: Vector2(0, unitHeight * 5),
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD90000),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M10 19.973c5.508 0 9.973-4.465 9.973-9.973 0-5.508-4.465-9.973-9.973-9.973C4.492.027.027 4.492.027 10c0 5.508 4.465 9.973 9.973 9.973Z",
                name: '4',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(38.03, 22.03),
                previousMustBePlaced: const ['0_1', '0_2'],
              ),
              EmblemPart.fromType<UgandaEmblem>(
                position: Vector2(43.98, 22.73),
                size: Vector2(10.4, 18.67),
                previousMustBePlaced: const ['4'],
              ),
            ];
          },
        );
}
