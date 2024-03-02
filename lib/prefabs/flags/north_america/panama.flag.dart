part of '../north_america.dart';

class PanamaFlag extends GameFlag {
  PanamaFlag()
      : super(
          name: "Panama",
          proportion: 2 / 3,
          objects: (size) {
            final path = parseSvgPathModel("M0 0h48v32H0V0Z");
            final starPath = parseSvgPathModel(
                "M10.398 6.111 8.412 0 6.426 6.111H0L5.2 9.89 3.213 16l5.198-3.777L13.61 16l-1.985-6.111 5.199-3.778h-6.427Z");

            return [
              PathPart.rect(
                name: '1',
                position: Vector2(0, 0),
                size: size,
                color: const Color(0xffffffff),
              ),
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF072357),
                  ),
                ),
                name: '2',
                position: Vector2(0, 32),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFDA121A),
                  ),
                ),
                name: '3',
                position: Vector2(48, 0),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF072357),
                  ),
                ),
                name: '4',
                position: Vector2(15.59, 8),
                previousMustBePlaced: const ['1'],
              ),
              PathPart(
                path: starPath.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFDA121A),
                  ),
                ),
                name: '5',
                position: Vector2(63.59, 40),
                previousMustBePlaced: const ['1'],
              ),
            ];
          },
        );
}
