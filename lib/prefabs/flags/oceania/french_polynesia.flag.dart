part of '../oceania.dart';

class FrenchPolynesiaFlag extends GameFlag {
  FrenchPolynesiaFlag()
      : super(
          name: "French Polynesia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '2',
              color: const Color(0xFFCE1126),
              areaSize: size,
            ),
            PathPart.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '3',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            EmblemPart.fromType<FrenchPolynesiaEmblem>(
              position: Vector2(34.24, 17.93),
              size: Vector2(27.52, 28.27),
              previousMustBePlaced: const ['3'],
            ),
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '2',
              color: const Color(0xFFCE1126),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
          ],
        );
}
