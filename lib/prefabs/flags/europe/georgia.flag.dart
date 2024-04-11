part of '../europe.dart';

class GeorgiaFlag extends GameFlag {
  GeorgiaFlag()
      : super(
          name: "Georgia",
          proportion: 2 / 3,
          objects: (size) {
            final part = parseSvgPathModel(
              "M8.798 0a17.28 17.28 0 0 1-4.501 0 33.28 33.28 0 0 1 .61 4.907A33.28 33.28 0 0 1 0 4.297a17.28 17.28 0 0 1 0 4.5 33.28 33.28 0 0 1 4.907-.61 33.28 33.28 0 0 1-.61 4.907 17.28 17.28 0 0 1 4.5 0 33.28 33.28 0 0 1-.61-4.907 33.28 33.28 0 0 1 4.907.61 17.279 17.279 0 0 1 0-4.5 33.28 33.28 0 0 1-4.906.61c.08-1.645.284-3.285.61-4.907Z",
              paint: SPaint(
                color: const Color(0xFFFF0000),
              ),
            );
            final cross = parseSvgPathModel(
              "M41.6 0h12.8v25.6H96v12.8H54.4V64H41.6V38.4H0V25.6h41.6V0Z",
              paint: SPaint(
                color: const Color(0xFFFF0000),
              ),
            );

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                path: cross,
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_1",
                position: Vector2(14.25, 6.25),
                path: part,
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_2",
                position: Vector2(14.25, 44.65),
                path: part,
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_3",
                position: Vector2(68.65, 44.65),
                path: part,
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_4",
                position: Vector2(68.65, 6.25),
                path: part,
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
