part of '../asia.dart';

class VietnamFlag extends GameFlag {
  VietnamFlag()
      : super(
          name: "Vietnam",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffDA251D),
            ),
            PathPart.fromSvgPath(
              "m14.163 14.263 4.32-13.28 4.321 13.28h13.951l-11.288 8.185 4.312 13.255-11.296-8.19-11.296 8.19L11.5 22.448.21 14.263h13.952Z",
              name: '2',
              color: const Color(0xFFFFFF00),
              areaSize: size,
              position: (_) => Vector2(29.73, 12.8),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
