part of '../africa.dart';

class RepublicOfTheCongoFlag extends GameFlag {
  RepublicOfTheCongoFlag()
      : super(
          name: "Republic of the congo",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 64V0h64L0 64Z",
              name: '1',
              color: const Color(0xff009543),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M64 0h32L32 64H0L64 0Z",
              name: '2',
              color: const Color(0xffFBDE4A),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M64 0v64H0L64 0Z",
              name: '3',
              color: const Color(0xffDA1A35),
              areaSize: size,
              position: (_) => Vector2(32, 0),
            ),
          ],
        );
}
