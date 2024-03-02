part of '../asia.dart';

class ThailandFlag extends GameFlag {
  ThailandFlag()
      : super(
          name: "Thailand",
          proportion: 2 / 3,
          objects: (size) {
            final part1 = parseSvgPathModel(
              "M0 0h96v10.667H0z",
              paint: SPaint(
                color: const Color(0xffA51931),
              ),
            );
            final part2 = parseSvgPathModel(
              "M0 .667h96v10.667H0z",
              paint: SPaint(
                color: const Color(0xffF4F5F8),
              ),
            );
            final part3 = parseSvgPathModel(
              "M96 .333H0v21.334h96V.333Z",
              paint: SPaint(
                color: const Color(0xff2D2A4A),
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
                position: Vector2(0, 10),
              ),
              PathPart(
                name: '3',
                path: part3,
                position: Vector2(0, 21),
              ),
              PathPart(
                name: '2',
                path: part2,
                position: Vector2(0, 42),
              ),
              PathPart(
                name: '1',
                path: part1,
                position: Vector2(0, 53),
              ),
            ];
          },
        );
}
