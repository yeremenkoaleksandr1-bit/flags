part of '../oceania.dart';

class NorfolkIslandFlag extends GameFlag {
  NorfolkIslandFlag()
      : super(
          name: "Norfolk Island",
          proportion: 1 / 2,
          objects: (size) {
            return [
              PathPart.fromSvgPath(
                "M39.157 0H.2v64h38.957V0Z",
                name: '1',
                areaSize: size,
                position: (bounds) => Vector2(0, 0),
                color: const Color(0xff007934),
              ),
              PathPart.fromSvgPath(
                "M50.244 0H.157v64h50.087V0Z",
                name: '2',
                areaSize: size,
                position: (bounds) => Vector2(38.96, 0),
                color: const Color(0xffffffff),
              ),
              PathPart.fromSvgPath(
                "M39.157 0H.2v64h38.957V0Z",
                name: '1',
                areaSize: size,
                position: (bounds) => Vector2(89.04, 0),
                color: const Color(0xff007934),
              ),
              EmblemPart.fromType<NorfolkIslandEmblem>(
                position: Vector2(47.11, 4.25),
                size: Vector2(33.79, 55.49),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
