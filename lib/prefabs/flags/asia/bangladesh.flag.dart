part of '../asia.dart';

class BangladeshFlag extends GameFlag {
  BangladeshFlag()
      : super(
          name: "Bangladesh",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff006A4E),
            ),
            PathGameObject.fromSvgPath(
                "M22 43.333c11.782 0 21.333-9.551 21.333-21.333C43.333 10.218 33.782.667 22 .667 10.218.667.667 10.217.667 22c0 11.782 9.55 21.333 21.333 21.333Z",
                name: '2',
                color: const Color(0xFFF42A41),
                areaSize: size,
                position: (_) => Vector2(26.67, 10.67),
                previousMustBePlaced: const ['1']),
          ],
        );
}
