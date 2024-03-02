part of '../oceania.dart';

class NauruFlag extends GameFlag {
  NauruFlag()
      : super(
          name: "Nauru",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff002B7F),
            ),
            PathPart.fromSvgPath(
              "M128.455.333h-128v5.334h128V.333Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffFFC61E),
              position: (bounds) => Vector2(0, 29.33),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "m11.455 22-1.38-5.515-3.953 4.086 1.562-5.466-5.466 1.562 4.086-3.953-5.515-1.38 5.515-1.381L2.218 6l5.466 1.562-1.562-5.466 3.953 4.086 1.38-5.515 1.38 5.515 3.954-4.086-1.563 5.466L20.694 6l-4.086 3.953 5.515 1.38-5.515 1.38 4.086 3.954-5.467-1.562 1.563 5.466-3.953-4.086L11.456 22Z",
              name: '3',
              areaSize: size,
              position: (bounds) => Vector2(21.33, 34.67),
              color: const Color(0xffffffff),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
