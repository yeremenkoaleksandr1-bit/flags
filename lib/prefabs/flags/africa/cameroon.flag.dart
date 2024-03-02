part of '../africa.dart';

class CameroonFlag extends GameFlag {
  CameroonFlag()
      : super(
          name: "Cameroon",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF007A5E),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "m8.222 12.387-4.997 3.63 1.909-5.874-4.997-3.63h6.176L8.223.637l1.908 5.874h6.176l-4.997 3.63 1.909 5.875-4.997-3.63Z",
                name: '4',
                color: const Color(0xFFFCD116),
                areaSize: size,
                position: (_) => Vector2(39.91, 23.38),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: "3",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFCD116),
                  ),
                ),
              ),
            ];
          },
        );
}
