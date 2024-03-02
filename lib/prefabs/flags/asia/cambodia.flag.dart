part of '../asia.dart';

class CambodiaFlag extends GameFlag {
  CambodiaFlag()
      : super(
          name: "Cambodia",
          proportion: 16 / 25,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0h100v16H0z",
              name: '1',
              color: const Color(0xff032EA1),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 0h100v32H0V0Z",
              name: '2',
              color: const Color(0xffE00025),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            PathPart.fromSvgPath(
              "M0 0h100v16H0z",
              name: '1',
              color: const Color(0xff032EA1),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
            EmblemPart.fromType<CambodiaEmblem>(
              position: Vector2(29.33, 18.64),
              size: Vector2(41.32, 26.66),
              previousMustBePlaced: const ['1', '2'],
            ),
          ],
        );
}
