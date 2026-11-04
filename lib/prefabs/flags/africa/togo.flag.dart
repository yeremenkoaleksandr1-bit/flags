part of '../africa.dart';

class TogoFlag extends GameFlag {
  TogoFlag()
      : super(
          name: "Togo",
          proportion: 1 / 1.625,
          objects: (size) {
            final part1 = parseSvgPathModel("M.4 0v12.8h65.6V0H.4Z");
            final part2 = parseSvgPathModel("M0 0v12.8h104.4V0H0Z");

            final paint1 = SPaint(
              color: const Color(0xff006A4E),
            );

            final paint2 = SPaint(
              color: const Color(0xffFFCE00),
            );

            return [
              PathGameObject(
                name: '1',
                uniqueName: "1_1",
                path: part1.copyWith(
                  paint: paint1,
                ),
                position: Vector2(38, 0),
              ),
              PathGameObject(
                name: '1',
                uniqueName: "1_2",
                path: part1.copyWith(
                  paint: paint1,
                ),
                position: Vector2(38, 25.6),
              ),
              PathGameObject(
                name: '2',
                path: part1.copyWith(
                  paint: paint2,
                ),
                position: Vector2(38, 12.8),
              ),
              PathGameObject(
                name: '3',
                path: part2.copyWith(
                  paint: paint2,
                ),
                position: Vector2(0, 38.4),
              ),
              PathGameObject(
                name: '4',
                path: part2.copyWith(
                  paint: paint1,
                ),
                position: Vector2(0, 51.2),
              ),
              PathGameObject.fromSvgPath(
                'M0 0h38.4v38.4H0V0Z',
                name: '5',
                position: (_) => Vector2(0, 0),
                color: const Color(0xffD21034),
                areaSize: size,
              ),
              PathGameObject.fromSvgPath(
                "M7.783 13.797.635 8.604H9.47L12.2.2l2.73 8.403h8.835l-7.148 5.193 2.73 8.402-7.147-5.193L5.052 22.2l2.73-8.402Z",
                name: '6',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(7, 7),
                previousMustBePlaced: const ['5'],
              ),
            ];
          },
        );
}
