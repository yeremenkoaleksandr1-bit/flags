part of '../north_america.dart';

class CubaFlag extends GameFlag {
  CubaFlag()
      : super(
          name: "Cuba",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h128v12.8H0V0Z",
              name: '1',
              uniqueName: "1_1",
              color: const Color(0xFF002A8F),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v12.8H0V0Z",
              name: '2',
              uniqueName: "2_1",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 12.8),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v12.8H0V0Z",
              name: '1',
              uniqueName: "1_2",
              color: const Color(0xFF002A8F),
              areaSize: size,
              position: (_) => Vector2(0, 25.6),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v12.8H0V0Z",
              name: '2',
              uniqueName: "2_2",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 38.4),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v12.8H0V0Z",
              name: '1',
              uniqueName: "1_3",
              color: const Color(0xFF002A8F),
              areaSize: size,
              position: (_) => Vector2(0, 51.2),
            ),
            PathGameObject.fromSvgPath(
              "M55.424 32 0 64V0l55.424 32Z",
              name: '3',
              color: const Color(0xFFCB1515),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1', '2'],
            ),
            PathGameObject.fromSvgPath(
              "M8.081 7.702 10.475.333l2.395 7.369h7.75l-6.27 4.557 2.397 7.372-6.271-4.556-6.27 4.556 2.395-7.371L.33 7.702h7.75Z",
              name: '4',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(8.33, 21.33),
              previousMustBePlaced: const ['3'],
            ),
          ],
        );
}
