part of '../asia.dart';

class OmanFlag extends GameFlag {
  OmanFlag()
      : super(
          name: "Oman",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M42.667 0H0v64h42.667V0Z",
              name: '1',
              color: const Color(0xffDF1A23),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M86 0H.667v21.334H86V0Z",
              name: '2',
              color: const Color(0xffFFFFFF),
              areaSize: size,
              position: (_) => Vector2(42, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M86 0H.667v21.334H86V0Z",
              name: '3',
              color: const Color(0xffDF1A23),
              areaSize: size,
              position: (_) => Vector2(42, 21.33),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M86 0H.667v21.334H86V0Z",
              name: '4',
              color: const Color(0xff007E3C),
              areaSize: size,
              position: (_) => Vector2(42, 42.67),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<OmanEmblem>(
              position: Vector2(12.07, 3.31),
              size: Vector2(18.53, 18.55),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
