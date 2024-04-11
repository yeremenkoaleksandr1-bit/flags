part of '../africa.dart';

class SaoTomeAndPrincipeFlag extends GameFlag {
  SaoTomeAndPrincipeFlag()
      : super(
          name: "São tomé and príncipe",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h128v18.286H0V0Z",
              name: '1',
              color: const Color(0xff009739),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 .286h128v27.428H0V.286Z",
              name: '2',
              color: const Color(0xffFFD100),
              areaSize: size,
              position: (_) => Vector2(0, 18.29),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v18.286H0V0Z",
              name: '1',
              color: const Color(0xff009739),
              areaSize: size,
              position: (_) => Vector2(0, 45.71),
            ),
            PathGameObject.fromSvgPath(
              "M32 32 0 64V0l32 32Z",
              name: '3',
              color: const Color(0xffEF3340),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1', '2'],
            ),
            PathGameObject.fromSvgPath(
              "M12.873 7.566 10.415 0 7.956 7.566H0l6.436 4.677-2.458 7.566 6.437-4.676 6.436 4.677-2.458-7.567 6.436-4.677h-7.956Z",
              name: '4',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(53.59, 22.1),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              "M12.873 7.566 10.415 0 7.956 7.566H0l6.436 4.677-2.458 7.566 6.437-4.676 6.436 4.677-2.458-7.567 6.436-4.677h-7.956Z",
              name: '4',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(85.59, 22.1),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
