part of '../north_america.dart';

class CostaRicaFlag extends GameFlag {
  CostaRicaFlag()
      : super(
          name: "Costa Rica",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '1',
              uniqueName: "1_1",
              color: const Color(0xFF001489),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '2',
              uniqueName: "2_1",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 10.67),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v21.333H0V0Z",
              name: '3',
              color: const Color(0xFFDA291C),
              areaSize: size,
              position: (_) => Vector2(0, 21.33),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '2',
              uniqueName: "2_2",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 42.67),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v10.667H0V0Z",
              name: '1',
              uniqueName: "1_2",
              color: const Color(0xFF001489),
              areaSize: size,
              position: (_) => Vector2(0, 53.33),
            ),
          ],
        );
}
