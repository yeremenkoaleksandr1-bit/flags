part of '../oceania.dart';

class FijiFlag extends GameFlag {
  FijiFlag()
      : super(
          name: "Fiji",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff62B5E5),
            ),
            EmblemPart.fromType<FijiEmblem>(
              position: Vector2(83.07, 15.35),
              size: Vector2(25.86, 33.28),
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
