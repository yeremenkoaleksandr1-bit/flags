part of '../asia.dart';

class SriLankaFlag extends GameFlag {
  SriLankaFlag()
      : super(
          name: "Sri Lanka",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffFFBE29),
            ),
            PathPart.fromSvgPath(
              "M.973.973h16.64v52.054H.973V.973Z",
              name: '2',
              color: const Color(0xff00534E),
              areaSize: size,
              position: (_) => Vector2(6, 6),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M.613.973h16.64v52.054H.613V.973Z",
              name: '3',
              color: const Color(0xffEB7400),
              areaSize: size,
              position: (_) => Vector2(22, 6),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M.227.973h76.8v52.054H.227V.973Z",
              name: '4',
              color: const Color(0xff8D153A),
              areaSize: size,
              position: (_) => Vector2(45, 6),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<SriLankaEmblem>(
              position: Vector2(47, 8),
              size: Vector2(73.17, 48.42),
              previousMustBePlaced: const ['4'],
            ),
          ],
        );
}
