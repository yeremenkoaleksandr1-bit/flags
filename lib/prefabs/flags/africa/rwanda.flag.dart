part of '../africa.dart';

class RwandaFlag extends GameFlag {
  RwandaFlag()
      : super(
          name: "Rwanda",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '1',
              color: const Color(0xff00A3E0),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            EmblemPart.fromType<RwandaEmblem>(
              position: Vector2(68.43, 6.4),
              size: Vector2(20.68, 20.68),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '2',
              color: const Color(0xffFAD201),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '3',
              color: const Color(0xff20603D),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
          ],
        );
}
