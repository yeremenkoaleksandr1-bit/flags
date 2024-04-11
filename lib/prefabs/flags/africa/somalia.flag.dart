part of '../africa.dart';

class SomaliaFlag extends GameFlag {
  SomaliaFlag()
      : super(
          name: "Somalia",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff4189DD),
            ),
            PathGameObject.fromSvgPath(
              "M18.113 10.646 14.652 0l-3.459 10.646H0l9.056 6.58-3.459 10.646 9.056-6.58 9.057 6.58-3.46-10.646 9.057-6.58H18.113Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(33.35, 17.06),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
