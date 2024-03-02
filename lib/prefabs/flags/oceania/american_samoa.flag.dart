part of '../oceania.dart';

class AmericanSamoaFlag extends GameFlag {
  AmericanSamoaFlag()
      : super(
          name: "American Samoa",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff000066),
            ),
            PathPart.fromSvgPath(
              "m.478 32 128-32v64l-128-32Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffBD1021),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M.192 29 114.478.43v57.14",
              name: '3',
              areaSize: size,
              position: (bounds) => Vector2(13.71, 3.43),
              color: const Color(0xffffffff),
              previousMustBePlaced: const ['2'],
            ),
            EmblemPart.fromType<AmericanSamoaEmblem>(
              position: Vector2(85.17, 9.72),
              size: Vector2(40.69, 41.55),
              previousMustBePlaced: const ['3'],
            ),
          ],
        );
}
