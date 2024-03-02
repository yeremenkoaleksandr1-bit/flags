part of '../africa.dart';

class CapeVerdeFlag extends GameFlag {
  CapeVerdeFlag()
      : super(
          name: "Cape verde",
          proportion: 10 / 17,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M.0.0h108.75V32H.0V.0Z",
              name: '1',
              color: const Color(0xff003893),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M.0.024h108.75V5.45H.0V.024Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 32.1),
            ),
            PathPart.fromSvgPath(
              "M.0.024h108.75V5.45H.0V.024Z",
              name: '3',
              color: const Color(0xffCF2027),
              areaSize: size,
              position: (_) => Vector2(0, 37.5),
            ),
            PathPart.fromSvgPath(
              "M.0.024h108.75V5.45H.0V.024Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 43),
            ),
            PathPart.fromSvgPath(
              "M.667.384h108.436V16H.0V.384Z",
              name: '4',
              color: const Color(0xff003893),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
            PathPart.fromSvgPath(
              "m3.176 22.875.675 2.075h2.187L4.27 26.233l.676 2.075-1.769-1.283-1.77 1.283.677-2.075-1.77-1.283H2.5m.495-12.933.676 2.074h2.186l-1.769 1.282.676 2.075-1.769-1.282-1.769 1.282.676-2.075-1.769-1.282H2.32m31.592-2.068.676 2.07h2.187l-1.77 1.28.677 2.07-1.77-1.279-1.769 1.28.676-2.07-1.769-1.28h2.186m.474 8.787.675 2.07h2.187l-1.769 1.28.676 2.07-1.77-1.278-1.768 1.279.675-2.07-1.768-1.28h2.186M18.45.85l.675 2.08h2.188l-1.77 1.285.676 2.08-1.77-1.285-1.768 1.285.676-2.08-1.769-1.285h2.186m.684 30.503.675 2.08h2.187l-1.769 1.285.676 2.08-1.77-1.286-1.769 1.285.676-2.08-1.769-1.284h2.187M8.892 3.952l.676 2.08h2.187l-1.77 1.284.677 2.08-1.77-1.285-1.768 1.285.675-2.08-1.768-1.285h2.186M27.996 30.34l.675 2.079h2.187l-1.769 1.285.676 2.08-1.77-1.285-1.768 1.285.675-2.08-1.769-1.285h2.187M9.227 30.586l.675 2.08h2.187l-1.77 1.284.677 2.08-1.77-1.285-1.768 1.285.675-2.08-1.769-1.285h2.187M27.719 3.713l.675 2.08h2.187l-1.768 1.285.675 2.08-1.769-1.285-1.77 1.285.677-2.08-1.769-1.285h2.186",
              name: '5',
              color: const Color(0xffF7D116),
              areaSize: size,
              position: (_) => Vector2(22.47, 20),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
          ],
        );
}
