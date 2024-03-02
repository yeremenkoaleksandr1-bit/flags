part of '../africa.dart';

class GuineaBissauFlag extends GameFlag {
  GuineaBissauFlag()
      : super(
          name: "Guinea Bissau",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M42.667 0H0v64h42.667V0Z",
              name: '1',
              color: const Color(0xffCE1126),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "m.189 7.704 6.27 4.555-2.395 7.37 6.27-4.555 6.269 4.556-2.395-7.37 6.27-4.556h-7.75L10.333.334 7.94 7.703H.189Z",
              name: '2',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(11.19, 21.33),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M86 0H.0v32H86V0Z",
              name: '3',
              color: const Color(0xffFCD116),
              areaSize: size,
              position: (_) => Vector2(42.67, 0),
            ),
            PathPart.fromSvgPath(
              "M86 0H.0v32H86V0Z",
              name: '4',
              color: const Color(0xff009E49),
              areaSize: size,
              position: (_) => Vector2(42.67, 32),
            ),
          ],
        );
}
