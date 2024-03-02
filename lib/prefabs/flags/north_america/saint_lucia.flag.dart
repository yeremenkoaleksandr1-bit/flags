part of '../north_america.dart';

class SaintLuciaFlag extends GameFlag {
  SaintLuciaFlag()
      : super(
          name: "Saint Lucia",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff66CCFF),
            ),
            PathPart.fromSvgPath(
              "M42.667 52.738 21.333 0 0 52.738h42.667Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(42.67, 5),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "m16.42 0 16.42 40.59H0L16.42 0Z",
              name: '3',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(47.58, 12.74),
              previousMustBePlaced: const ['2'],
            ),
            PathPart.fromSvgPath(
              "m21.333-.442 21.334 26.369H0L21.333-.443Z",
              name: '4',
              color: const Color(0xFFFCD116),
              areaSize: size,
              position: (_) => Vector2(42.67, 32),
              previousMustBePlaced: const ['3'],
            ),
          ],
        );
}
