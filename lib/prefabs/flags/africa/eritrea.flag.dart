part of '../africa.dart';

class EritreaFlag extends GameFlag {
  EritreaFlag()
      : super(
          name: "Eritrea",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h128v32L0 0Z",
              name: '1',
              color: const Color(0xff43B02A),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "m0 0 128 32L0 64V0Z",
              name: '2',
              color: const Color(0xffE4002B),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            EmblemPart.fromType<EritreaEmblem>(
              position: Vector2(16, 17.33),
              size: Vector2(32, 32),
              previousMustBePlaced: const ['2'],
            ),
            PathPart.fromSvgPath(
              "M128 0v32H0L128 0Z",
              name: '3',
              color: const Color(0xff418FDE),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
          ],
        );
}
