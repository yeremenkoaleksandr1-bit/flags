part of '../asia.dart';

class BahrainFlag extends GameFlag {
  BahrainFlag()
      : super(
          name: "Bahrain",
          proportion: 3 / 5,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M26.666 0H0v64h26.666l16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4Z",
              name: '1',
              color: const Color(0xFFffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M.667 0h80v64h-80l16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4 16-6.4-16-6.4Z",
              name: '2',
              color: const Color(0xFFDA291C),
              areaSize: size,
              position: (_) => Vector2(26, 0),
            ),
          ],
        );
}
