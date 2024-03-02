part of '../north_america.dart';

class CostaRicaFlag extends GameFlag {
  CostaRicaFlag()
      : super(
          name: "Costa Rica",
          proportion: 3 / 5,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '1',
              color: const Color(0xFF001489),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 10.67),
            ),
            PathPart.fromSvgPath(
              "M0 0h106.667v21.333H0V0Z",
              name: '3',
              color: const Color(0xFFDA291C),
              areaSize: size,
              position: (_) => Vector2(0, 21.33),
            ),
            PathPart.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 42.67),
            ),
            PathPart.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '1',
              color: const Color(0xFF001489),
              areaSize: size,
              position: (_) => Vector2(0, 53.33),
            ),
          ],
        );
}
