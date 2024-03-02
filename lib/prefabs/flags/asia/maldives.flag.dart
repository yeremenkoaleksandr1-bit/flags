part of '../asia.dart';

class MaldivesFlag extends GameFlag {
  MaldivesFlag()
      : super(
          name: "Maldives",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffD21034),
            ),
            PathPart.fromSvgPath(
              "M64 0H0v32h64V0Z",
              name: '2',
              color: const Color(0xff007E3A),
              areaSize: size,
              position: (_) => Vector2(16, 16),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<MaldivesEmblem>(
              position: Vector2(41.3, 21.33),
              size: Vector2(12.67, 21.33),
              previousMustBePlaced: const ['1', '2'],
            ),
          ],
        );
}
