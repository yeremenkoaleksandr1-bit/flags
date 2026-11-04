part of '../oceania.dart';

class PalauFlag extends GameFlag {
  PalauFlag()
      : super(
          name: "Palau",
          proportion: 5 / 8,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff0099FF),
            ),
            PathGameObject.fromSvgPath(
              "M19.6 39.2c10.604 0 19.2-8.596 19.2-19.2S30.204.8 19.6.8.4 9.396.4 20s8.596 19.2 19.2 19.2Z",
              name: '2',
              areaSize: size,
              position: (bounds) => Vector2(25.6, 12.8),
              color: const Color(0xffFFFF00),
              previousMustBePlaced: const ['1'],
            )
          ],
        );
}
