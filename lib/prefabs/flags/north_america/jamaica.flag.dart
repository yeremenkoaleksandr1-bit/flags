part of '../north_america.dart';

class JamaicaFlag extends GameFlag {
  JamaicaFlag()
      : super(
          name: "Jamaica",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M116.074 64 64 37.963 11.926 64H0v-5.963L52.074 32 0 5.963V0h11.926L64 26.037 116.074 0H128v5.963L75.926 32 128 58.037V64h-11.926Z",
              name: '1',
              color: const Color(0xFFFFB81C),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "m0 52.074 52.074-26.037L0 0v52.074Z",
              name: '2',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(0, 5.96),
            ),
            PathGameObject.fromSvgPath(
              "M52.074 52.074 0 26.037 52.074 0v52.074Z",
              name: '3',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(75.93, 5.96),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h104.149L52.074 26.037 0 0Z",
              name: '4',
              color: const Color(0xFF007749),
              areaSize: size,
              position: (_) => Vector2(11.93, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 27h104.149L52.074.963 0 27Z",
              name: '5',
              color: const Color(0xFF007749),
              areaSize: size,
              position: (_) => Vector2(11.93, 37),
            ),
          ],
        );
}
