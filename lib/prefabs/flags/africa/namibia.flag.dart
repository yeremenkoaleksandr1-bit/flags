part of '../africa.dart';

class NamibiaFlag extends GameFlag {
  NamibiaFlag()
      : super(
          name: "Namibia",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M-.062.162v51.183L76.701.162H-.062Z",
              name: '1',
              color: const Color(0xff002F6C),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            EmblemPart.fromType<NamibiaEmblem>(
              position: Vector2(8.53, 6.76),
              size: Vector2(21.33, 21.33),
              previousMustBePlaced: ['1'],
            ),
            PathPart.fromSvgPath(
              "M76.701.162-.062 51.345v3.203L81.516.161h-4.815Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M81.516.162h14.422v9.615L14.36 64.162H-.061v-9.615L81.516.163Z",
              name: '3',
              color: const Color(0xffC8102E),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M81.939.777.36 55.162h4.751L81.94 3.937V.777Z",
              name: '4',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(14, 9),
            ),
            PathPart.fromSvgPath(
              "M76.938 52.162V.938L.112 52.161h76.826Z",
              name: '5',
              color: const Color(0xff009A44),
              areaSize: size,
              position: (_) => Vector2(18.9, 12),
            ),
          ],
        );
}
