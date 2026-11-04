part of '../africa.dart';

class LibyaFlag extends GameFlag {
  LibyaFlag()
      : super(
          name: "Libya",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M128 0H0v16h128V0Z",
              name: '1',
              color: const Color(0xffE70013),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M128 0H0v32h128V0Z",
              name: '2',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            EmblemPart.fromType<LibyaEmblem>(
              position: Vector2(56, 24),
              size: Vector2(22.65, 16),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              "M128 0H0v16h128V0Z",
              name: '3',
              color: const Color(0xff239E46),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
          ],
        );
}
