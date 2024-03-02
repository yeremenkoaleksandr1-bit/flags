part of '../south_america.dart';

class EcuadorFlag extends GameFlag {
  EcuadorFlag()
      : super(
          name: "Ecuador",
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
            EmblemPart.fromType<EcuadorEmblem>(
              position: Vector2(34.68, 16.02),
              size: Vector2(26.64, 31.96),
              previousMustBePlaced: const ['1', '2'],
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
