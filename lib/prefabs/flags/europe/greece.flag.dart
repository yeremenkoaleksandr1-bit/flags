part of '../europe.dart';

class GreeceFlag extends GameFlag {
  GreeceFlag()
      : super(
          name: "Greece",
          proportion: 2 / 3,
          objects: (size) {
            final cross = parseSvgPathModel(
              "M14.222 0v14.222H0v7.111h14.222V35.52h7.111V21.333h14.223v-7.11H21.333V0h-7.11Z",
              paint: SPaint(
                color: const Color(0xFFFFFFFF),
              ),
            );

            final shortLine = parseSvgPathModel(
              "M61 7.222H.556V.112H61v7.11Z",
              paint: SPaint(
                color: const Color(0xFFFFFFFF),
              ),
            );
            final longLine = parseSvgPathModel(
              "M96 7.667H0V.556h96v7.11Z",
              paint: SPaint(
                color: const Color(0xFFFFFFFF),
              ),
            );

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0D5EAF),
                  ),
                ),
              ),
              PathPart(
                name: '2',
                path: shortLine,
                position: Vector2(size.x - shortLine.bounds.width, 7.11),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                name: '2',
                path: shortLine,
                position: Vector2(size.x - shortLine.bounds.width, 21.33),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                name: '3',
                path: longLine,
                position: Vector2(0, 34.93),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                name: '3',
                path: longLine,
                position: Vector2(0, 49.78),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                name: '4',
                path: cross,
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
