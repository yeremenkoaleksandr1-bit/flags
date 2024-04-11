part of '../south_america.dart';

class ChileFlag extends GameFlag {
  ChileFlag()
      : super(
          name: "Chile",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h32v32H0V0Z",
              name: '1',
              color: const Color(0xFF0039A6),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M7.608 0 5.812 5.528H0l4.702 3.416-1.796 5.528 4.702-3.416 4.702 3.416-1.796-5.528 4.702-3.416H9.404L7.608 0Z",
              name: '4',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(8.39, 8),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M0 0h64v32H0V0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(32, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '3',
              color: const Color(0xFFD72B1F),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
          ],
        );
}
