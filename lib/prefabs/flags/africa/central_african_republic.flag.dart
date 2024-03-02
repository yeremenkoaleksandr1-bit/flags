part of '../africa.dart';

class CentralAfricanRepublicFlag extends GameFlag {
  CentralAfricanRepublicFlag()
      : super(
          name: "Central african republic",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 4;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF003082),
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
                    color: const Color(0xFFffffff),
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
                    color: const Color(0xFF289728),
                  ),
                ),
              ),
              PathPart(
                name: "4",
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFCE00),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "M0 0h16v64H0V0Z",
                name: '5',
                color: const Color(0xffD21034),
                areaSize: size,
                position: (_) => Vector2(40, 0),
                previousMustBePlaced: const ['1', '2', '3', '4'],
              ),
              PathPart.fromSvgPath(
                "M9.005 5.694 7.39.719 5.773 5.694H.54l4.232 3.075-1.616 4.975 4.232-3.075 4.232 3.075-1.616-4.975 4.232-3.075H9.005Z",
                name: '6',
                color: const Color(0xFFFFCE00),
                areaSize: size,
                position: (_) => Vector2(9, 0.5),
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
