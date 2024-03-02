part of '../africa.dart';

class DjiboutiFlag extends GameFlag {
  DjiboutiFlag()
      : super(
          name: "Djibouti",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M96 0H0l55.426 32H96V0Z",
              name: '1',
              color: const Color(0xff6AB2E7),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0v64l55.426-32L0 0Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "m9.212 0 1.985 6.111h6.426L12.425 9.89 14.41 16l-5.2-3.777L4.014 16 6 9.889.8 6.11h6.426L9.212 0Z",
              name: '4',
              color: const Color(0xffD7141A),
              areaSize: size,
              position: (_) => Vector2(12.8, 24),
              previousMustBePlaced: const ['2'],
            ),
            PathPart.fromSvgPath(
              "M0 32h96V0H55.426L0 32Z",
              name: '3',
              color: const Color(0xff12AD2B),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
          ],
        );
}
