part of '../africa.dart';

class SouthSudanFlag extends GameFlag {
  SouthSudanFlag()
      : super(
          name: "South sudan",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h128v19.088H0V0Z",
              name: '1',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 .088h128v3.368H0V.088Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 19),
            ),
            PathPart.fromSvgPath(
              "M0 .456h128v19.088H0V.456Z",
              name: '3',
              color: const Color(0xffDA121A),
              areaSize: size,
              position: (_) => Vector2(0, 22),
            ),
            PathPart.fromSvgPath(
              "M0 .088h128v3.368H0V.088Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 41.5),
            ),
            PathPart.fromSvgPath(
              "M0 .912h128V20H0V.912Z",
              name: '4',
              color: const Color(0xff078930),
              areaSize: size,
              position: (_) => Vector2(0, 44),
            ),
            PathPart.fromSvgPath(
              "M55.425 32 0 64V0l55.425 32Z",
              name: '5',
              color: const Color(0xff0F47AF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
            PathPart.fromSvgPath(
              "M8.18 13.395.807 11l7.371-2.395V.855l4.555 6.27 7.37-2.395L15.55 11l4.555 6.27-7.37-2.395-4.556 6.27v-7.75Z",
              name: '6',
              color: const Color(0xffFCDD09),
              areaSize: size,
              position: (_) => Vector2(7, 21),
              previousMustBePlaced: const ['5'],
            ),
          ],
        );
}
