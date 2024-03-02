part of '../africa.dart';

class LesothoFlag extends GameFlag {
  LesothoFlag()
      : super(
          name: "Lesotho",
          proportion: 2 / 3,
          objects: (size) {
            return [
              PathPart.fromSvgPath(
                "M0 0h96v19.2H0V0Z",
                name: '1',
                color: const Color(0xff001489),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathPart.fromSvgPath(
                "M0 .0h96v25.6H0V.2Z",
                name: '2',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(0, 19.2),
              ),
              EmblemPart.fromType<LesothoEmblem>(
                position: Vector2(37.58, 20.22),
                size: Vector2(20.83, 23.55),
                previousMustBePlaced: const ['2'],
              ),
              PathPart.fromSvgPath(
                "M0 .0h96V20H0V.8Z",
                name: '3',
                color: const Color(0xff009A44),
                areaSize: size,
                position: (_) => Vector2(0, 44.8),
              ),
            ];
          },
        );
}
