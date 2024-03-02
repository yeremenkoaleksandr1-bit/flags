part of '../africa.dart';

class SouthAfricaFlag extends GameFlag {
  SouthAfricaFlag()
      : super(
          name: "South africa",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M76.77 0H0l30.672 20.448H76.77V0Z",
              name: '1',
              color: const Color(0xffE03C31),
              areaSize: size,
              position: (_) => Vector2(19.23, 0),
            ),
            PathPart.fromSvgPath(
              "M19.23 64H0V0h19.23L49.9 20.448H96V42.69H51.192L19.23 64Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 7.692 36.462 32 0 56.308V64h11.538l38.4-25.6H96V25.6H49.938L11.538 0H0v7.692Z",
              name: '4',
              color: const Color(0xff007749),
              areaSize: size,
              previousMustBePlaced: const ['2'],
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M36.462 25 0 .692v48.616L36.462 25Z",
              name: '5',
              color: const Color(0xffFFB81C),
              areaSize: size,
              previousMustBePlaced: const ['2'],
              position: (_) => Vector2(0, 7),
            ),
            PathPart.fromSvgPath(
              "M0 .82 28.77 20 0 39.18V.82Z",
              name: '6',
              color: const Color(0xff000000),
              areaSize: size,
              previousMustBePlaced: const ['5'],
              position: (_) => Vector2(0, 12),
            ),
            PathPart.fromSvgPath(
              "M0 22h76.77V.691H31.963L0 22Z",
              name: '3',
              color: const Color(0xff001489),
              areaSize: size,
              position: (_) => Vector2(19.23, 42),
            ),
          ],
        );
}
