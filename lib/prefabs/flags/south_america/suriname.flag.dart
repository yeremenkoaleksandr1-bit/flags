part of '../south_america.dart';

class SurinameFlag extends GameFlag {
  SurinameFlag()
      : super(
          name: "Suriname",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M96 0H0v12.8h96V0Z",
              name: '1',
              uniqueName: "1_1",
              color: const Color(0xFF377E3F),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M96 0H0v6.4h96V0Z",
              name: '2',
              uniqueName: "2_1",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 12.8),
            ),
            PathGameObject.fromSvgPath(
              "M96 0H0v25.6h96V0Z",
              name: '3',
              color: const Color(0xFFB40A2D),
              areaSize: size,
              position: (_) => Vector2(0, 19.2),
            ),
            PathGameObject.fromSvgPath(
              "M15.047 8.845 12.174 0 9.3 8.845H0l7.524 5.466-2.874 8.844 7.524-5.466 7.523 5.466-2.874-8.844 7.524-5.466h-9.3Z",
              name: '4',
              color: const Color(0xFFECC81D),
              areaSize: size,
              position: (_) => Vector2(35.83, 20.42),
              previousMustBePlaced: const ['3'],
            ),
            PathGameObject.fromSvgPath(
              "M96 0H0v6.4h96V0Z",
              name: '2',
              uniqueName: "2_2",
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 44.8),
            ),
            PathGameObject.fromSvgPath(
              "M96 0H0v12.8h96V0Z",
              name: '1',
              uniqueName: "1_2",
              color: const Color(0xFF377E3F),
              areaSize: size,
              position: (_) => Vector2(0, 51.2),
            ),
          ],
        );
}
