part of '../europe.dart';

class BosniaAndHerzegovinaFlag extends GameFlag {
  BosniaAndHerzegovinaFlag()
      : super(
          name: "Bosnia and Herzegovina",
          proportion: 1 / 2,
          objects: (size) {
            final star = parseSvgPathModel(
              "m2.209 10.999 1.365-4.201L0 4.2h4.417L5.782 0l1.365 4.201h4.418L7.99 6.798l1.365 4.2-3.574-2.596L2.21 11Z",
              paint: SPaint(
                color: const Color(0xFFFFFFFF),
              ),
            );

            final triangle = parseSvgPathModel(
              "M.92 0h64v64L.92 0Z",
              paint: SPaint(
                color: const Color(0xFFFECB00),
              ),
            );

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    color: const Color(0xFF002395),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                path: triangle,
                position: Vector2(33.92, 0),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_1",
                path: star,
                position: Vector2(16.62, -6.8),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_2",
                path: star,
                position: Vector2(24.62, 1.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_3",
                path: star,
                position: Vector2(32.62, 9.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_4",
                path: star,
                position: Vector2(40.62, 17.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_5",
                path: star,
                position: Vector2(48.62, 25.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_6",
                path: star,
                position: Vector2(56.62, 33.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_7",
                path: star,
                position: Vector2(64.62, 41.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_8",
                path: star,
                position: Vector2(72.62, 49.2),
                previousMustBePlaced: const ["1"],
              ),
              PathGameObject(
                name: '2',
                uniqueName: "2_8",
                path: star,
                position: Vector2(80.62, 57.2),
                previousMustBePlaced: const ["1"],
              ),
            ];
          },
        );
}
