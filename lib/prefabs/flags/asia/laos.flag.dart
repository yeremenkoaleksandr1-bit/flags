part of '../asia.dart';

class LaosFlag extends GameFlag {
  LaosFlag()
      : super(
          name: "Laos",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '1',
              color: const Color(0xffCE1126),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '2',
              color: const Color(0xff002868),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            PathPart.fromSvgPath(
              "M0 0h96v16H0V0Z",
              name: '1',
              color: const Color(0xffCE1126),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
            PathPart.fromSvgPath(
              "M13 25.8c7.07 0 12.8-5.73 12.8-12.8S20.07.2 13 .2C5.931.2.2 5.93.2 13S5.93 25.8 13 25.8Z",
              name: '3',
              color: const Color(0xffFFFFFF),
              areaSize: size,
              position: (_) => Vector2(35.2, 19.2),
              previousMustBePlaced: const ['1', '2'],
            ),
          ],
        );
}
