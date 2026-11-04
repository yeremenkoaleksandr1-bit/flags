part of '../asia.dart';

class IsraelFlag extends GameFlag {
  IsraelFlag()
      : super(
          name: "Israel",
          proportion: 8 / 11,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffffffff),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h88v10H0V0Z",
              name: '2',
              uniqueName: "2_1",
              color: const Color(0xff0038B8),
              areaSize: size,
              position: (_) => Vector2(0, 6),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<IsraelEmblem>(
              position: Vector2(32, 18.14),
              size: Vector2(24, 27.71),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M0 0h88v10H0V0Z",
              name: '2',
              uniqueName: "2_2",
              color: const Color(0xff0038B8),
              areaSize: size,
              position: (_) => Vector2(0, 48),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
