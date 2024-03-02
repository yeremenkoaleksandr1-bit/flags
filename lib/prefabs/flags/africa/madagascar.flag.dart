part of '../africa.dart';

class MadagascarFlag extends GameFlag {
  MadagascarFlag()
      : super(
          name: "Madagascar",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M32 0H0v64h32V0Z",
              name: '1',
              color: const Color(0xffFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M64 0H0v32h64V0Z",
              name: '2',
              color: const Color(0xffFC3D32),
              areaSize: size,
              position: (_) => Vector2(32, 0),
            ),
            PathPart.fromSvgPath(
              "M64 0H0v32h64V0Z",
              name: '3',
              color: const Color(0xff007E3A),
              areaSize: size,
              position: (_) => Vector2(32, 32),
            ),
          ],
        );
}
