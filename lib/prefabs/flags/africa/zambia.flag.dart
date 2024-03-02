part of '../africa.dart';

class ZambiaFlag extends GameFlag {
  ZambiaFlag()
      : super(
          name: "Zambia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff198A00),
            ),
            PathPart.fromSvgPath(
              "M.318.856h11.42V42H.318z",
              name: '2',
              color: const Color(0xffDE2010),
              areaSize: size,
              position: (_) => Vector2(61.73, 22.86),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M.318.856h11.42V42H.318z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(73.16, 22.86),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M.318.856h11.42V42H.318z",
              name: '4',
              color: const Color(0xffEF7D00),
              areaSize: size,
              position: (_) => Vector2(84.58, 22.86),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<ZambiaEmblem>(
              position: Vector2(63.77, 5.48),
              size: Vector2(30.18, 11.9),
              previousMustBePlaced: const ['1'],
            )
          ],
        );
}
