part of '../north_america.dart';

class GrenadaFlag extends GameFlag {
  GrenadaFlag()
      : super(
          name: "Grenada",
          proportion: 3 / 5,
          objects: (size) {
            final starPath = parseSvgPathModel(
              "M3.022 2.874 3.957 0l.934 2.874h3.023L5.468 4.651 6.4 7.526 3.956 5.749 1.511 7.526l.934-2.875L0 2.874h3.022Z",
              paint: SPaint(
                color: const Color(0xffFCD116),
              ),
            );

            return [
              PathPart.rect(
                name: '1',
                position: Vector2.zero(),
                size: size,
                color: const Color(0xffCE1126),
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(28.04, 0.32),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(49.38, 0.32),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(70.71, 0.32),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(28.04, 55.36),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(49.38, 55.36),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath,
                name: '6',
                position: Vector2(70.71, 55.36),
                previousMustBePlaced: const ['1'],
              ),
              PathPart.fromSvgPath(
                "M.96.96v46.08L45.333 24 .96.96Z",
                name: '2',
                color: const Color(0xFF007A5E),
                areaSize: size,
                position: (_) => Vector2(8, 8),
                previousMustBePlaced: const ['1'],
              ),
              PathPart.fromSvgPath(
                "M44.707.96v46.08L.333 24 44.707.96Z",
                name: '3',
                color: const Color(0xFF007A5E),
                areaSize: size,
                position: (_) => Vector2(53, 8),
                previousMustBePlaced: const ['1'],
              ),
              PathPart.fromSvgPath(
                "M89.707.96H.96L45.333 24 89.707.96Z",
                name: '4',
                color: const Color(0xFFFCD116),
                areaSize: size,
                position: (_) => Vector2(8, 8),
                previousMustBePlaced: const ['1'],
              ),
              PathPart.fromSvgPath(
                "M89.707 23.04H.96L45.333 0l44.374 23.04Z",
                name: '5',
                color: const Color(0xFFFCD116),
                areaSize: size,
                position: (_) => Vector2(8, 32),
                previousMustBePlaced: const ['1'],
              ),
              GroupedPathsPart(
                name: 'grenade_1',
                position: Vector2(12.53, 25.92),
                previousMustBePlaced: const ['2'],
                size: Vector2(64, 32),
                objects: (visualSize) => [
                  PathPart.fromSvgPath(
                    "M.125 1.781C1.035 3.598 2.846 5.6 4.458 6.33c.079-1.816-.5-4.163-1.328-6.044L.126 1.781Z",
                    name: '1',
                    color: const Color(0xFFCE1126),
                    areaSize: size,
                    position: (_) => Vector2(1.96, 4.61),
                  ),
                  PathPart.fromSvgPath(
                    "M.49.675c1.355 2.921-3.74 9.782 4.577 11.514-1.01-1.417-1.563-3.787-1.288-5.644 1.727.736 3.458 2.446 4.139 4.048C10.786 2.596 2.274 3.356.49.675Z",
                    name: '2',
                    color: const Color(0xFFFCD116),
                    areaSize: size,
                  ),
                ],
              ),
              GroupedPathsPart(
                name: 'grenade_2',
                position: Vector2(45, 24),
                previousMustBePlaced: const ['2', '3', '4', '5'],
                objects: (visualSize) => [
                  PathPart.fromSvgPath(
                    "M8.333 15.68a7.68 7.68 0 1 0 0-15.36 7.68 7.68 0 0 0 0 15.36Z",
                    name: '1',
                    color: const Color(0xFFCE1126),
                    areaSize: size,
                  ),
                  PathPart.fromSvgPath(
                    "M5.753 4.954 7.333.09l1.581 4.864h5.115L9.89 7.961l1.58 4.864L7.334 9.82l-4.138 3.006 1.58-4.864L.639 4.954h5.115Z",
                    name: '2',
                    color: const Color(0xFFFCD116),
                    areaSize: size,
                    position: (_) => Vector2(0.98, 0.77),
                  ),
                ],
              ),
            ];
          },
        );
}
