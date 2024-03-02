part of '../oceania.dart';

class MarshallIslandsFlag extends GameFlag {
  MarshallIslandsFlag()
      : super(
          name: "Marshall Islands",
          proportion: 10 / 19,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff003893),
            ),
            PathPart.fromSvgPath(
              "M0 61.01v1.024L121.6 13.65V.082v1.024L0 61.01Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffDD7500),
              position: (_) => Vector2(0, 0.5),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M121.6 13.106V.562L0 48.946v1.024l121.6-36.864Z",
              name: '3',
              areaSize: size,
              color: const Color(0xffffffff),
              position: (_) => Vector2(0, 13.56),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "m20.368.528.819 13.621 2.857-7.505-1.277 7.928 4.705-6.51-3.287 7.329 6.228-5.071-5.069 6.228 7.327-3.284-6.51 4.702 7.931-1.277-7.506 2.86 13.622.819-13.622.819 7.506 2.857-7.93-1.278 6.51 4.706-7.327-3.287 5.068 6.228-6.228-5.069 3.287 7.327-4.705-6.51 1.277 7.93-2.857-7.505-.82 13.622-.818-13.622-2.86 7.506 1.278-7.931-4.703 6.51 3.284-7.327-6.228 5.07 5.071-6.23-7.33 3.288 6.511-4.706-7.928 1.278 7.506-2.857-13.622-.82 13.622-.819-7.506-2.859 7.928 1.277-6.51-4.702 7.33 3.284-5.072-6.228 6.228 5.071-3.284-7.33 4.703 6.51-1.278-7.927 2.86 7.505.819-13.621Z",
              name: '4',
              areaSize: size,
              color: const Color(0xffffffff),
              position: (_) => Vector2(3.53, 3.53),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
