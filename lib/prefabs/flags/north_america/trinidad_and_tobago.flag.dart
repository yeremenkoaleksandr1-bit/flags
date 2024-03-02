part of '../north_america.dart';

class TrinidadAndTobagoFlag extends GameFlag {
  TrinidadAndTobagoFlag()
      : super(
          name: "Trinidad and Tobago",
          proportion: 3 / 5,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 0v64h74.043L0 0Z",
              name: '1',
              color: const Color(0xFFDA1A35),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "m0 0 74.043 64h32.624L32.623 0H0Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "m0 0 74.043 64h21.75L21.748 0H0Z",
              name: '4',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(5.44, 0),
              previousMustBePlaced: const ['2'],
            ),
            PathPart.fromSvgPath(
              "M0 0h74.043v64L0 0Z",
              name: '3',
              color: const Color(0xFFDA1A35),
              areaSize: size,
              position: (_) => Vector2(32.62, 0),
            ),
          ],
        );
}
