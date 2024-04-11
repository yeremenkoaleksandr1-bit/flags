part of '../africa.dart';

class BurundiFlag extends GameFlag {
  BurundiFlag()
      : super(
          name: "Burundi",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "m0 0 53.334 32 53.333-32H0Z",
              name: '1',
              color: const Color(0xffC8102E),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M106.668 32H0L53.334 0l53.334 32Z",
              name: '2',
              color: const Color(0xffC8102E),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
            PathGameObject.fromSvgPath(
              "m0 0 53.334 32L0 64V0Z",
              name: '3',
              color: const Color(0xff43B02A),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M53.668 64 .335 32 53.668 0v64Z",
              name: '4',
              color: const Color(0xff43B02A),
              areaSize: size,
              position: (_) => Vector2(53.33, 0),
            ),
            PathGameObject.fromSvgPath(
              "m98.375 64-45.04-27.024L8.295 64H0v-4.975L45.042 32 .001 4.976V0h8.293l45.04 27.024L98.376 0h8.294v4.976L61.628 32l45.041 27.025V64h-8.294Z",
              name: '5',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
            PathGameObject.fromSvgPath(
              "M18.333 37.133c10.015 0 18.133-8.118 18.133-18.133C36.466 8.985 28.348.867 18.333.867 8.318.867.2 8.985.2 19c0 10.015 8.118 18.133 18.133 18.133Z",
              name: '6',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(35.2, 13.87),
              previousMustBePlaced: const ['1', '2', '3', '4'],
            ),
            GroupedPathsPart(
              name: 'burundi_stars',
              position: Vector2(41.51, 18.35),
              previousMustBePlaced: const ['6'],
              size: size,
              objects: (size) => [
                PathGameObject.fromSvgPath(
                  'm12.333.347 1.232 2.133h2.463l-1.231 2.133 1.23 2.134h-2.462L12.333 8.88l-1.232-2.133H8.638L9.87 4.613 8.64 2.48h2.46L12.333.347Zm8.137 14.089 1.233 2.133h2.463l-1.231 2.134 1.23 2.133h-2.462L20.47 22.97l-1.232-2.133h-2.463l1.231-2.133-1.23-2.134h2.462l1.232-2.133Zm-16.263-.031L5.44 16.54h2.463l-1.23 2.133 1.23 2.133H5.44L4.207 22.94l-1.231-2.134H.513l1.23-2.133-1.23-2.133h2.463l1.231-2.134Z',
                  name: '',
                  areaSize: size,
                  position: (_) => Vector2(0, 0),
                  color: const Color(0xff43B02A),
                ),
                PathGameObject.fromSvgPath(
                  'm11.333.092 1.017 1.76h2.033l-1.016 1.761 1.016 1.761H12.35l-1.017 1.761-1.017-1.76H8.284L9.3 3.612l-1.016-1.76h2.032l1.017-1.76ZM3.207 14.15l1.017 1.761h2.033L5.24 17.672l1.016 1.76H4.224l-1.017 1.762-1.016-1.761H.158l1.016-1.76L.158 15.91h2.033l1.016-1.76Zm16.263.031 1.018 1.76h2.032l-1.015 1.762 1.015 1.76h-2.032l-1.017 1.761-1.017-1.76h-2.032l1.015-1.761-1.015-1.761h2.032l1.017-1.76Z',
                  name: '',
                  areaSize: size,
                  position: (_) => Vector2(1, 1),
                  color: const Color(0xffC8102E),
                ),
              ],
            ),
          ],
        );
}
