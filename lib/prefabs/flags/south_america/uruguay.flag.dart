part of '../south_america.dart';

class UruguayFlag extends GameFlag {
  UruguayFlag()
      : super(
          name: "Uruguay",
          proportion: 2 / 3,
          objects: (size) {
            final part1 = parseSvgPathModel("M0 0h60.444v7.111H0V0Z");
            final part2 = parseSvgPathModel("M0 0h96v7.111H0V0Z");

            return [
              PathGameObject(
                path: part1.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                name: '1',
                uniqueName: "1_1",
                position: Vector2(35.56, 0),
              ),
              PathGameObject(
                path: part1.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF0038A8),
                  ),
                ),
                name: '2',
                uniqueName: "2_1",
                position: Vector2(35.56, 7.11),
              ),
              PathGameObject(
                path: part1.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                name: '1',
                uniqueName: "1_2",
                position: Vector2(35.56, 14.18),
              ),
              PathGameObject(
                path: part1.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF0038A8),
                  ),
                ),
                name: '2',
                uniqueName: "2_2",
                position: Vector2(35.56, 21.33),
              ),
              PathGameObject(
                path: part2.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                name: '3',
                uniqueName: '3_1',
                position: Vector2(0, 28.36),
              ),
              PathGameObject.fromSvgPath(
                "M0 0h35.556v28.364H0V0Z",
                name: '5',
                color: const Color(0xFFFFFFFF),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              EmblemPart.fromType<UruguayEmblem>(
                position: Vector2(4.87, 4.39),
                size: Vector2(26.28, 26.77),
                previousMustBePlaced: const ['5'],
              ),
              PathGameObject(
                path: part2.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF0038A8),
                  ),
                ),
                name: '4',
                uniqueName: "4_1",
                position: Vector2(0, 35.56),
              ),
              PathGameObject(
                path: part2.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                name: '3',
                uniqueName: "3_1",
                position: Vector2(0, 42.67),
              ),
              PathGameObject(
                path: part2.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF0038A8),
                  ),
                ),
                name: '4',
                uniqueName: "4_2",
                position: Vector2(0, 49.78),
              ),
              PathGameObject(
                path: part2.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                name: '3',
                uniqueName: "3_2",
                position: Vector2(0, 56.85),
              ),
            ];
          },
        );
}
