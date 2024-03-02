part of '../north_america.dart';

class AntiguaAndBarbudaFlag extends GameFlag {
  AntiguaAndBarbudaFlag()
      : super(
          name: "Antigua and Barbuda",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 2;
            double unitFlex = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF000000),
                  ),
                  rect: Vector2(size.x, unitFlex).toRect(),
                ),
              ),
              PathPart.fromSvgPath(
                "m31.104 18.834 10.635 2.036H0l10.635-2.036-9.046-5.951 10.604 2.189-6.08-8.96 8.959 6.081-2.19-10.604 5.952 9.046L20.87 0l2.035 10.635 5.951-9.046-2.189 10.604 8.96-6.08-6.081 8.959 10.604-2.19-9.046 5.952Z",
                name: '3',
                color: const Color(0xFFFCD116),
                areaSize: size,
                position: (_) => Vector2(27.13, 4.17),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
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
              PathPart.fromSvgPath(
                "M0 0h96v13.913H0V0Z",
                name: '4',
                color: const Color(0xFF0072C6),
                areaSize: size,
                position: (_) => Vector2(0, 25.04),
                previousMustBePlaced: const ['1', '2'],
              ),
              PathPart.fromSvgPath(
                "M48 64 0 0v64h48Z",
                name: '5',
                color: const Color(0xFFCE1126),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '4'],
              ),
              PathPart.fromSvgPath(
                "M0 64 48 0v64H0Z",
                name: '6',
                color: const Color(0xFFCE1126),
                areaSize: size,
                position: (_) => Vector2(48, 0),
                previousMustBePlaced: const ['1', '2', '4'],
              ),
            ];
          },
        );
}
