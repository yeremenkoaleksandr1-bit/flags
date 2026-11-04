part of '../north_america.dart';

class SaintVincentAndTheGrenadinesFlag extends GameFlag {
  SaintVincentAndTheGrenadinesFlag()
      : super(
          name: "Saint Vincent and the Grenadines",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h24v64H0V0Z",
              name: '1',
              color: const Color(0xFF002674),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h48v64H0V0Z",
              name: '2',
              color: const Color(0xFFFCD022),
              areaSize: size,
              position: (_) => Vector2(24, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h24v64H0V0Z",
              name: '3',
              color: const Color(0xFF007C2E),
              areaSize: size,
              position: (_) => Vector2(72, 0),
            ),
            PathGameObject.fromSvgPath(
              "M12 10.392 6 0 0 10.392l6 10.392 6-10.392Zm14.4 0L20.4 0l-6 10.392 6 10.392 6-10.392Zm-7.2 12.471-6-10.393-6 10.393 6 10.392 6-10.392Z",
              name: '4',
              color: const Color(0xFF007C2E),
              areaSize: size,
              position: (_) => Vector2(34.8, 20.78),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
