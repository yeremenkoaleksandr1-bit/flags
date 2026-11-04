part of '../south_america.dart';

class GuyanaFlag extends GameFlag {
  GuyanaFlag()
      : super(
          name: "Guyana",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff2A936A),
            ),
            PathGameObject.fromSvgPath(
              "M0 0v64l106.667-32L0 0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "m0 0 99.242 29.773L0 59.545V0Z",
              name: '3',
              color: const Color(0xFFFFC20E),
              areaSize: size,
              position: (_) => Vector2(0, 2.23),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              "m0 0 53.333 32L0 64",
              name: '4',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['3'],
            ),
            PathGameObject.fromSvgPath(
              "m0 0 49.187 29.512L0 59.024V0Z",
              name: '5',
              color: const Color(0xFFBE1E2D),
              areaSize: size,
              position: (_) => Vector2(0, 2.49),
              previousMustBePlaced: const ['4'],
            ),
          ],
        );
}
