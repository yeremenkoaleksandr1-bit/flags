part of '../asia.dart';

class JordanFlag extends GameFlag {
  JordanFlag()
      : super(
          name: "Jordan",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
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
                    color: const Color(0xFFffffff),
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
                    color: const Color(0xFF007A3D),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "m64 32.083-64 32v-64",
                name: '4',
                color: const Color(0xffCE1126),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
              PathGameObject.fromSvgPath(
                "m3.774 2.946.99-2.514 1.003 2.514 2.578-.787L7 4.495 9.221 6.02l-2.666.406.203 2.692L4.764 7.29l-1.98 1.828.202-2.692L.307 6.02l2.235-1.524L1.196 2.16l2.578.787Z",
                name: '5',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(15.31, 27.43),
                previousMustBePlaced: const ['4'],
              ),
            ];
          },
        );
}
