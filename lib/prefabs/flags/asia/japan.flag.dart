part of '../asia.dart';

class JapanFlag extends GameFlag {
  JapanFlag()
      : super(
          name: "Japan",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffffffff),
            ),
            PathGameObject.fromSvgPath(
              "M20 39.2c10.604 0 19.2-8.596 19.2-19.2S30.604.8 20 .8.8 9.396.8 20 9.396 39.2 20 39.2Z",
              name: '2',
              color: const Color(0xFFBC002D),
              areaSize: size,
              position: (_) => Vector2(28.8, 12.8),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
