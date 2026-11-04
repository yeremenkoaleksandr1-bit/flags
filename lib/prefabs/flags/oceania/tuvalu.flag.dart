part of '../oceania.dart';

class TuvaluFlag extends GameFlag {
  TuvaluFlag()
      : super(
          name: "Tuvalu",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff009CDE),
            ),
            PathGameObject.fromSvgPath(
              "m54.933.925 1.26 3.875h4.074L56.97 7.195l1.26 3.875-3.297-2.395-3.296 2.395 1.26-3.875L49.6 4.8h4.074l1.26-3.875ZM5.866 49.992l1.259 3.875h4.074l-3.296 2.395 1.259 3.875-3.296-2.395-3.297 2.395 1.26-3.875-3.297-2.395h4.075l1.259-3.875ZM54.933 26.541l1.26 3.875h4.074l-3.297 2.395 1.26 3.875-3.297-2.395-3.296 2.395 1.26-3.875-3.297-2.395h4.074l1.26-3.875ZM43.733 33.459l1.26 3.875h4.074l-3.297 2.395 1.26 3.875-3.297-2.395-3.296 2.395 1.26-3.875-3.297-2.395h4.074l1.26-3.875ZM43.733 22.274l1.26-3.875h4.074l-3.297-2.394 1.26-3.875-3.297 2.395-3.296-2.395 1.26 3.875L38.4 18.4h4.074l1.26 3.875ZM32.533 26.526l1.26-3.875h4.074l-3.296-2.395 1.259-3.875-3.297 2.395-3.296-2.395 1.26 3.875L27.2 22.65h4.075l1.258 3.875ZM19.2 44.675l1.259-3.875h4.074l-3.296-2.395 1.26-3.875-3.297 2.395-3.296-2.395 1.259 3.875-3.296 2.395h4.074l1.259 3.875ZM19.2 58.008l1.259-3.875h4.074l-3.296-2.395 1.259-3.875-3.296 2.395-3.297-2.395 1.26 3.875-3.297 2.395h4.075l1.259 3.875ZM32.534 54.275l1.259-3.875h4.074l-3.296-2.395 1.26-3.875-3.297 2.395-3.296-2.395 1.259 3.875-3.296 2.395h4.074l1.259 3.875Z",
              name: '2',
              color: const Color(0xFFFEDD00),
              areaSize: size,
              position: (_) => Vector2(64.53, 1.93),
              previousMustBePlaced: const ['1'],
            ),
            GroupedPathsPart(
              name: 'flag_uk',
              position: Vector2.zero(),
              size: Vector2(64, 32),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathGameObject.rect(
                  name: "1",
                  size: visualSize,
                  color: const Color(0xff012169),
                  position: Vector2.zero(),
                ),
                PathGameObject.fromSvgPath(
                  "M0 3.578 24.845 16 0 28.422V32h7.155L32 19.578 56.844 32H64v-3.578L39.155 16 64 3.578V0h-7.156L32 12.422 7.155 0H0v3.578Z",
                  name: '2',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 2.385 27.23 16H32L0 32h4.77L32 18.385V16l32 16v-2.385L36.77 16H32L64 0h-4.77L32 13.615V16L0 0v2.385Z",
                  name: '3',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 10.707v10.706h26.667V32.01h10.666V21.413H64V10.707H37.333V0H26.667v10.707H0Z",
                  name: '4',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 12.8v6.4h28.8V32h6.4V19.2H64v-6.4H35.2V0h-6.4v12.8H0Z",
                  name: '5',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                ),
              ],
            ),
          ],
        );
}
