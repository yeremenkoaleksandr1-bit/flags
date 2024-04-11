part of '../africa.dart';

class KenyaFlag extends GameFlag {
  KenyaFlag()
      : super(
          name: "Kenya",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h96v19.2H0V0Z",
              name: '1',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 .0h96v3.2H0V.2Z",
              name: '2',
              uniqueName: "2_1",
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 19.2),
            ),
            PathGameObject.fromSvgPath(
              "M0 .0h96v19.2H0V.4Z",
              name: '3',
              color: const Color(0xffBB0000),
              areaSize: size,
              position: (_) => Vector2(0, 22.4),
            ),
            PathGameObject.fromSvgPath(
              "M0 .0h96v3.2H0V.2Z",
              name: '2',
              uniqueName: "2_2",
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 41.6),
            ),
            PathGameObject.fromSvgPath(
              "M0 .0h96V20H0V.8Z",
              name: '4',
              color: const Color(0xff006600),
              areaSize: size,
              position: (_) => Vector2(0, 44.8),
            ),
            EmblemPart.fromType<KenyaEmblem>(
              position: Vector2(34.76, 9.07),
              size: Vector2(26.48, 42.6),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
          ],
        );
}
