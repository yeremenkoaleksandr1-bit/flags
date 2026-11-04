part of '../asia.dart';

class EastTimorFlag extends GameFlag {
  EastTimorFlag()
      : super(
          name: "East Timor",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffDA291C),
            ),
            PathGameObject.fromSvgPath(
              "M64 32 0 64V0l64 32Z",
              name: '2',
              color: const Color(0xffFFC72C),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M42.667 32 0 64V0l42.667 32Z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              "M12.178 6.568 6.997.805l.805 7.708L.72 11.661l7.58 1.616.804 7.708 3.88-6.71 7.579 1.617-5.182-5.763 3.88-6.708-7.082 3.147Z",
              name: '4',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(3.61, 22.25),
              previousMustBePlaced: const ['3'],
            ),
          ],
        );
}
