part of '../oceania.dart';

class NewZealandFlag extends GameFlag {
  NewZealandFlag()
      : super(
          name: "New Zealand",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff012169),
            ),
            GroupedPathsPart(
              name: "stars",
              position: Vector2(76.35, 7.71),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathPart.fromSvgPath(
                  "m20.462.708 1.144 3.518h3.699l-2.993 2.175 1.143 3.518-2.992-2.175L17.47 9.92l1.143-3.52-2.993-2.174h3.7L20.462.708ZM5.674 15.62l1.143 3.518h3.7l-2.993 2.174 1.143 3.518-2.993-2.175L2.68 24.83l1.143-3.518-2.992-2.175H4.53l1.143-3.518Zm27.464-3.332 1.017 3.13h3.292l-2.663 1.935 1.017 3.13-2.663-1.934-2.663 1.935 1.017-3.13-2.663-1.936h3.292l1.017-3.13ZM20.462 38.547l1.27 3.906h4.107l-3.323 2.414 1.27 3.906-3.324-2.415-3.322 2.415 1.27-3.906-3.324-2.414h4.107l1.27-3.906Z",
                  name: '2',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "m18.463.459.755 2.325h2.445L19.685 4.22l.756 2.325-1.978-1.437-1.978 1.437.756-2.325-1.978-1.437h2.444l.756-2.325ZM3.675 15.337l.755 2.325h2.445l-1.978 1.437.756 2.325-1.978-1.437-1.978 1.437.756-2.325-1.978-1.437h2.444l.756-2.325ZM18.463 38.27l.888 2.734h2.875l-2.326 1.69.888 2.733-2.325-1.69-2.326 1.69.889-2.734-2.326-1.69 2.875.001.888-2.734Zm12.675-26.232.63 1.938h2.037l-1.648 1.197.63 1.937-1.649-1.197-1.648 1.197.63-1.937-1.649-1.197h2.038l.63-1.938Z",
                  name: '3',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                  position: (_) => Vector2(2, 2),
                ),
              ],
            ),
            GroupedPathsPart(
              name: 'flag_uk',
              position: Vector2.zero(),
              size: Vector2(64, 32),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathPart.rect(
                  name: "1",
                  size: visualSize,
                  color: const Color(0xff012169),
                  position: Vector2.zero(),
                ),
                PathPart.fromSvgPath(
                  "M0 3.578 24.845 16 0 28.422V32h7.155L32 19.578 56.844 32H64v-3.578L39.155 16 64 3.578V0h-7.156L32 12.422 7.155 0H0v3.578Z",
                  name: '2',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "M0 2.385 27.23 16H32L0 32h4.77L32 18.385V16l32 16v-2.385L36.77 16H32L64 0h-4.77L32 13.615V16L0 0v2.385Z",
                  name: '3',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "M0 10.707v10.706h26.667V32.01h10.666V21.413H64V10.707H37.333V0H26.667v10.707H0Z",
                  name: '4',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
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
