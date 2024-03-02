part of '../south_america.dart';

class ColombiaFlag extends GameFlag {
  ColombiaFlag()
      : super(
          name: "Colombia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M96 0H0v32h96V0Z",
              name: '1',
              color: const Color(0xFFFFDD00),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M96 0H0v16h96V0Z",
              name: '2',
              color: const Color(0xFF034EA2),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
            PathPart.fromSvgPath(
              "M96 0H0v16h96V0Z",
              name: '3',
              color: const Color(0xFFED1C24),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
          ],
        );
}
