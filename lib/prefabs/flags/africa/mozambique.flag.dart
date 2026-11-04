part of '../africa.dart';

class MozambiqueFlag extends GameFlag {
  MozambiqueFlag()
      : super(
          name: "Mozambique",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h96v20H0V0Z",
              name: '1',
              color: const Color(0xff007168),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v2H0V0Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 20),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v20H0V0Z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 22),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v2H0V0Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 42),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v20H0V0Z",
              name: '4',
              color: const Color(0xffFCE100),
              areaSize: size,
              position: (_) => Vector2(0, 44),
            ),
            PathGameObject.fromSvgPath(
              "M0 0v64l42-32L0 0Z",
              name: '5',
              color: const Color(0xffD21034),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
            PathGameObject.fromSvgPath(
              "m20.8 23.998-7.804-5.713L5.204 24l3.022-9.187L.383 9.168l9.67.036L13 0l2.955 9.209 9.663-.043-7.845 5.655 3.027 9.177Z",
              name: '6',
              color: const Color(0xffFCE100),
              areaSize: size,
              position: (_) => Vector2(0.8, 19.4),
              previousMustBePlaced: const ['5'],
            ),
            EmblemPart.fromType<MozambiqueEmblem>(
              position: Vector2(3.57, 22.76),
              size: Vector2(20.79, 17.09),
              previousMustBePlaced: const ['6'],
            ),
          ],
        );
}
