part of '../asia.dart';

class MalaysiaFlag extends GameFlag {
  MalaysiaFlag()
      : super(
          name: "Malaysia",
          proportion: 1 / 2,
          objects: (size) {
            final paint = SPaint(color: const Color(0xffCC0000));
            final smallLine = parseSvgPathModel(
              "M64 4.571H0V0h64v4.571Z",
              paint: paint,
            );

            final longLine = parseSvgPathModel(
              "M128 5.143H0V.572h128v4.571Z",
              paint: paint,
            );

            return [
              PathGameObject.rect(
                name: '1',
                uniqueName: "1_1",
                position: Vector2.zero(),
                size: size,
                color: const Color(0xffffffff),
              ),
              PathGameObject(
                path: smallLine,
                name: '2',
                uniqueName: "2_1",
                position: Vector2(64, 0),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: smallLine,
                name: '2',
                uniqueName: "2_2",
                position: Vector2(64, 9),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: smallLine,
                name: '2',
                uniqueName: "2_3",
                position: Vector2(64, 18),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: smallLine,
                name: '2',
                uniqueName: "2_4",
                position: Vector2(64, 27),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: longLine,
                name: '3',
                uniqueName: "3_1",
                position: Vector2(0, 36),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: longLine,
                name: '3',
                uniqueName: "3_2",
                position: Vector2(0, 45),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                path: longLine,
                name: '3',
                uniqueName: "3_3",
                position: Vector2(0, 54),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject.fromSvgPath(
                "M0 0h64v36.572H0V0Z",
                name: '4',
                color: const Color(0xff000066),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1'],
              ),
              EmblemPart.fromType<MalaysiaEmblem>(
                position: Vector2(12.58, 4.57),
                size: Vector2(38.57, 27.43),
                previousMustBePlaced: const ['4'],
              )
            ];
          },
        );
}
