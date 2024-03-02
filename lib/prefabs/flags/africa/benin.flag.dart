part of '../africa.dart';

class BeninFlag extends GameFlag {
  BeninFlag()
      : super(
          name: "Benin",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M.158 0h38.4v64H.158V0Z",
              name: '1',
              color: const Color(0xff008751),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M.558 0h57.6v32H.558V0Z",
              name: '2',
              color: const Color(0xffFCD116),
              areaSize: size,
              position: (_) => Vector2(38, 0),
            ),
            PathPart.fromSvgPath(
              "M.558 0h57.6v32H.558V0Z",
              name: '3',
              color: const Color(0xffE8112D),
              areaSize: size,
              position: (_) => Vector2(38, 32),
            ),
          ],
        );
}
