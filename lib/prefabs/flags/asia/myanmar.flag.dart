part of '../asia.dart';

class MyanmarFlag extends GameFlag {
  MyanmarFlag()
      : super(
          name: "Myanmar",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFECB00),
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
                    color: const Color(0xFF34B233),
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
                    color: const Color(0xFFEA2839),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M17.705 16.963H.57l13.863 10.071-5.295 16.297L23 33.259l13.862 10.072-5.295-16.297 13.863-10.07H28.295L23 .667l-5.295 16.296Z",
                name: '4',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(25.57, 10.67),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
