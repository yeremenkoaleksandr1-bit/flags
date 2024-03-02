part of '../oceania.dart';

class TongaFlag extends GameFlag {
  TongaFlag()
      : super(
          name: "Tonga",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffC10000),
            ),
            PathPart.fromSvgPath(
              "M53.333 0H0v32h53.333V0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M8.666 0h8v8h8v8h-8v8h-8v-8h-8V8h8V0Z",
              name: '3',
              color: const Color(0xFFC10000),
              areaSize: size,
              position: (_) => Vector2(13.5, 4),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
