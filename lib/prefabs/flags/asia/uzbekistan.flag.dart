part of '../asia.dart';

class UzbekistanFlag extends GameFlag {
  UzbekistanFlag()
      : super(
          name: "Uzbekistan",
          proportion: 1 / 2,
          objects: (size) {
            final part1 = parseSvgPathModel(
              "M0 0h128v20.48H0V0Z",
              paint: SPaint(
                color: const Color(0xff0099B5),
              ),
            );
            final part2 = parseSvgPathModel(
              "M0 .48h128v23.04H0V.48Z",
              paint: SPaint(
                color: const Color(0xffCE1126),
              ),
            );
            final part3 = parseSvgPathModel(
              "M0 .76h128v20.48H0V.76Z",
              paint: SPaint(
                color: const Color(0xffFFFFFF),
              ),
            );

            final part4 = parseSvgPathModel(
              "M0 .52h128V21H0V.52Z",
              paint: SPaint(
                color: const Color(0xff1EB53A),
              ),
            );

            return [
              PathPart(
                name: '1',
                path: part1,
                position: Vector2(0, 0),
              ),
              PathPart(
                name: '2',
                path: part2,
                position: Vector2(0, 20),
              ),
              PathPart(
                name: '3',
                path: part4,
                position: Vector2(0, 43),
              ),
              PathPart(
                name: '4',
                path: part3,
                position: Vector2(0, 21),
                previousMustBePlaced: const ['2'],
              ),
              EmblemPart.fromType<UzbekistanEmblem>(
                position: Vector2(10.24, 2.5),
                size: Vector2(38.32, 15.36),
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
