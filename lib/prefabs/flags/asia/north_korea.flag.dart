part of '../asia.dart';

class NorthKoreaFlag extends GameFlag {
  NorthKoreaFlag()
      : super(
          name: "North Korea",
          proportion: 1 / 2,
          objects: (size) {
            final part1 = parseSvgPathModel(
              "M0 0h128v10.667H0z",
              paint: SPaint(
                color: const Color(0xff024FA2),
              ),
            );
            final part2 = parseSvgPathModel(
              "M0 .667h128v1.778H0z",
              paint: SPaint(
                color: const Color(0xffFFFFFF),
              ),
            );
            final part3 = parseSvgPathModel(
              "M128 .444H0v39.112h128V.444Z",
              paint: SPaint(
                color: const Color(0xffED1C27),
              ),
            );

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: part1,
                position: Vector2(0, 0),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_1",
                path: part2,
                position: Vector2(0, 10),
              ),
              PathGameObject(
                name: '3',
                uniqueName: "3_1",
                path: part3,
                position: Vector2(0, 12),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_2",
                path: part2,
                position: Vector2(0, 51),
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                path: part1,
                position: Vector2(0, 53.33),
              ),
              GroupedPathsPart(
                name: 'flag_uk',
                previousMustBePlaced: const ['3'],
                position: Vector2(28.44, 17.78),
                size: Vector2(28.44, 28.44),
                objects: (visualSize) => [
                  PathGameObject.fromSvgPath(
                    "M14.667 29.222c7.854 0 14.222-6.367 14.222-14.222C28.889 7.145 22.52.778 14.667.778 6.812.778.444 7.145.444 15c0 7.855 6.368 14.222 14.223 14.222Z",
                    name: '3',
                    color: const Color(0xFFffffff),
                    areaSize: size,
                  ),
                  PathGameObject.fromSvgPath(
                    "M8.661 15.626.563 9.742h10.01l3.093-9.52 3.094 9.52h10.01l-8.098 5.884 3.093 9.52-8.099-5.884-8.098 5.884 3.093-9.52Z",
                    name: '4',
                    color: const Color(0xFFED1C27),
                    position: (_) => Vector2(1.12, 1),
                    areaSize: size,
                  ),
                ],
              ),
            ];
          },
        );
}
