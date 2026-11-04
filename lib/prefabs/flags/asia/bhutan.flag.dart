part of '../asia.dart';

class BhutanFlag extends GameFlag {
  BhutanFlag()
      : super(
          name: "Bhutan",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M96 0H0v64L96 0Z",
              name: '1',
              color: const Color(0xffFFCD00),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 64h96V0L0 64Z",
              name: '2',
              color: const Color(0xffFF671F),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            EmblemPart.fromType<BhutanEmblem>(
              position: Vector2(13.71, 7.94),
              size: Vector2(68.27, 49.8),
              previousMustBePlaced: const ['1', '2'],
            )
          ],
        );
}
