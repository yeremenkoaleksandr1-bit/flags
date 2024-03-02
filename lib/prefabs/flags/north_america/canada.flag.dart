part of '../north_america.dart';

class CanadaFlag extends GameFlag {
  CanadaFlag()
      : super(
          name: "Canada",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h32v64H0V0Z",
              name: '1',
              color: const Color(0xFFD52B1E),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0h64v64H0z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(32, 0),
            ),
            EmblemPart.fromType<CanadaEmblem>(
              position: Vector2(39, 5),
              size: Vector2(49.6, 53.73),
              previousMustBePlaced: ['2'],
            ),
            PathPart.fromSvgPath(
              "M0 0h32v64H0V0Z",
              name: '1',
              color: const Color(0xFFD52B1E),
              areaSize: size,
              position: (_) => Vector2(96, 0),
            ),
          ],
        );
}
