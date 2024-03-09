part of '../north_america.dart';

class DominicaFlag extends GameFlag {
  DominicaFlag()
      : super(
          name: "Dominica",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff046A38),
            ),
            PathPart.fromSvgPath(
              "M61.333 0H56v24H0v5.333h56V64h5.333V29.333H128V24H61.333V0Z",
              name: '2',
              color: const Color(0xFFFFCD00),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M72 0h-5.333v34.667H0V40h66.667v24H72V40h56v-5.333H72V0Z",
              name: '4',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M66.667 0h-5.334v29.333H0v5.334h61.333V64h5.334V34.667H128v-5.334H66.667V0Z",
              name: '3',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<DominicaEmblem>(
              position: Vector2(48, 16),
              size: Vector2(32, 32),
              previousMustBePlaced: const ['2', '3', '4'],
            ),
          ],
        );
}
