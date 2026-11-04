part of '../oceania.dart';

class NewCaledoniaFlag extends GameFlag {
  NewCaledoniaFlag()
      : super(
          name: "New Caledonia",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h128v21.333H0z",
              name: '1',
              areaSize: size,
              color: const Color(0xff0035AD),
            ),
            PathGameObject.fromSvgPath(
              "M0 .333h128v18.56H0z",
              name: '2',
              areaSize: size,
              color: const Color(0xffED4135),
              position: (_) => Vector2(0, 21),
            ),
            PathGameObject.fromSvgPath(
              "M0 .893h128V25H0z",
              name: '3',
              areaSize: size,
              color: const Color(0xff009543),
              position: (_) => Vector2(0, 39),
            ),
            EmblemPart.fromType<KanakEmblem>(
              position: Vector2(21.69, 11.03),
              size: Vector2(41.95, 41.95),
              previousMustBePlaced: const ['1', '2', '3'],
            ),
          ],
        );
}
