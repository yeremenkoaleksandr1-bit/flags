part of '../asia.dart';

class NepalFlag extends GameFlag {
  NepalFlag()
      : super(
          name: "Nepal",
          proportion: 1.22 / 1,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "m0 0 52.502 32.878H19.36l31.122 31.123H0V0Z",
              name: '1',
              color: const Color(0xff003893),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "m.894.421 44.013 27.563H13.785l31.122 31.122H.895V.42Z",
              name: '2',
              color: const Color(0xffDC143C),
              areaSize: size,
              position: (_) => Vector2(0.8, 3),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<NepalMoonStarEmblem>(
              position: Vector2(4.13, 19.17),
              size: Vector2(17.53, 10.24),
              previousMustBePlaced: const ['2'],
            ),
            EmblemPart.fromType<NepalStarEmblem>(
              position: Vector2(3.48, 37.13),
              size: Vector2(18.84, 18.84),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
