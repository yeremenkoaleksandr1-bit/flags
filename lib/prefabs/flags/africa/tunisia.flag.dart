part of '../africa.dart';

class TunisiaFlag extends GameFlag {
  TunisiaFlag()
      : super(
          name: "Tunisia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffE70013),
            ),
            PathPart.fromSvgPath(
              "M16 32c8.837 0 16-7.163 16-16S24.837 0 16 0 0 7.163 0 16s7.163 16 16 16Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(32, 16),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<TunisiaEmblem>(
              position: Vector2(36, 20),
              size: Vector2(21.7, 24),
              previousMustBePlaced: ['2'],
            )
          ],
        );
}
