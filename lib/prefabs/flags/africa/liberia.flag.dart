part of '../africa.dart';

class LiberiaFlag extends GameFlag {
  LiberiaFlag()
      : super(
          name: "Liberia",
          proportion: 10 / 19,
          objects: (size) {
            final part1 = parseSvgPathModel("M0 0h92.51v5.818H0V0Z");
            final part2 = parseSvgPathModel("M121.6 5.818H0V0h121.6v5.818Z");

            final paint1 = SPaint(color: const Color(0xffBF0A30));
            final paint2 = SPaint(color: const Color(0xffFFFFFF));

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: part1.copyWith(
                  paint: paint1,
                ),
                position: Vector2(29.09, 0),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_1",
                path: part1.copyWith(
                  paint: paint2,
                ),
                position: Vector2(29.09, 5.82),
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                path: part1.copyWith(
                  paint: paint1,
                ),
                position: Vector2(29.09, 11.64),
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_2",
                path: part1.copyWith(
                  paint: paint2,
                ),
                position: Vector2(29.09, 17.45),
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_3",
                path: part1.copyWith(
                  paint: paint1,
                ),
                position: Vector2(29.09, 23.27),
              ),
              PathGameObject(
                name: '3',
                uniqueName: "3_1",
                path: part2.copyWith(
                  paint: paint2,
                ),
                position: Vector2(0, 29),
              ),
              PathGameObject(
                name: '4',
                uniqueName: "4_1",
                path: part2.copyWith(
                  paint: paint1,
                ),
                position: Vector2(0, 34.91),
              ),
              PathGameObject(
                name: '3',
                uniqueName: "3_2",
                path: part2.copyWith(
                  paint: paint2,
                ),
                position: Vector2(0, 40.73),
              ),
              PathGameObject(
                name: '4',
                uniqueName: "4_2",
                path: part2.copyWith(
                  paint: paint1,
                ),
                position: Vector2(0, 46.55),
              ),
              PathGameObject(
                name: '3',
                uniqueName: "3_3",
                path: part2.copyWith(
                  paint: paint2,
                ),
                position: Vector2(0, 52.36),
              ),
              PathGameObject(
                name: '4',
                uniqueName: "4_3",
                path: part2.copyWith(
                  paint: paint1,
                ),
                position: Vector2(0, 58.18),
              ),
              PathGameObject.fromSvgPath(
                "M0 0h29.09v29.091H0V0Z",
                name: '5',
                color: const Color(0xff002868),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathGameObject.fromSvgPath(
                "m.246 6.849 5.13 3.727-1.96 6.03 5.13-3.727 5.13 3.727-1.96-6.03 5.13-3.727h-6.34L8.545.819l-1.96 6.03H.246Z",
                name: '6',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(5.6, 5),
                previousMustBePlaced: const ['5'],
              ),
            ];
          },
        );
}
