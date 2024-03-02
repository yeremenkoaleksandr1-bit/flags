part of '../asia.dart';

class LebanonFlag extends GameFlag {
  LebanonFlag()
      : super(
          name: "Lebanon",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h96v16H0z",
              name: '1',
              color: const Color(0xffED1C24),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            EmblemPart.fromType<LebanonEmblem>(
              position: Vector2(32.46, 16),
              size: Vector2(31.49, 31.97),
              previousMustBePlaced: const ['2'],
            ),
            PathPart.fromSvgPath(
              "M0 0h96v16H0z",
              name: '1',
              color: const Color(0xffED1C24),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
          ],
        );
}
