part of '../south_america.dart';

class BrazilFlag extends GameFlag {
  BrazilFlag()
      : super(
          name: "Brazil",
          proportion: 7 / 10,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff009B3A),
            ),
            PathGameObject.fromSvgPath(
              "m.771 25 37.943 24.23L76.657 25 38.714.771.771 25.001Z",
              name: '2',
              color: const Color(0xFFFEDF00),
              areaSize: size,
              position: (_) => Vector2(7.77, 7.77),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<BrazilEmblem>(
              position: Vector2(29.71, 16),
              size: Vector2(32, 32),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
