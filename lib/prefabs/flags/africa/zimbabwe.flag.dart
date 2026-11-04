part of '../africa.dart';

class ZimbabweFlag extends GameFlag {
  ZimbabweFlag()
      : super(
          name: "Zimbabwe",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 7;
            final double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF006400),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: "2",
                uniqueName: "2_1",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFD200),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                uniqueName: "3_1",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD40000),
                  ),
                ),
              ),
              PathGameObject(
                name: "4",
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                uniqueName: "3_2",
                position: Vector2(0, unitHeight * 4),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD40000),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                uniqueName: "2_2",
                position: Vector2(0, unitHeight * 5),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFD200),
                  ),
                ),
              ),
              PathGameObject(
                name: "1",
                uniqueName: "1_2",
                position: Vector2(0, unitHeight * 6),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF006400),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M45.365 32 2.698 0H.158v64h2.54l42.667-32Z",
                name: '5',
                color: const Color(0xff000000),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
              PathGameObject.fromSvgPath(
                "M42.825 32 .158 64V0l42.667 32Z",
                name: '6',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['5'],
              ),
              PathGameObject.fromSvgPath(
                "m14.412.537-3.194 9.828H.886l8.36 6.073-3.193 9.828 8.36-6.074 8.36 6.074-3.194-9.828 8.36-6.073H17.605L14.412.537Z",
                name: '7',
                color: const Color(0xffD40000),
                areaSize: size,
                position: (_) => Vector2(2, 16),
                previousMustBePlaced: const ['6'],
              ),
              EmblemPart.fromType<ZimbabweEmblem>(
                position: Vector2(11.15, 21.43),
                size: Vector2(12.35, 17.34),
                previousMustBePlaced: const ['7'],
              ),
            ];
          },
        );
}
