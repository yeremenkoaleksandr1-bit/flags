part of '../asia.dart';

class RepublicOfChinaFlag extends GameFlag {
  RepublicOfChinaFlag()
      : super(
          name: "Republic of China",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffFE0000),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h48v32H0V0Z",
              name: '2',
              color: const Color(0xFF000095),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<RepublicOfChinaEmblem>(
              position: Vector2(12, 4),
              size: Vector2(24, 24),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
