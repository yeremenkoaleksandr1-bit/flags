part of '../oceania.dart';

class NorthernMarianaIslandsFlag extends GameFlag {
  NorthernMarianaIslandsFlag()
      : super(
          name: "Northern Mariana Islands",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xFF0033A1),
            ),
            EmblemPart.fromType<NorthernMarianaIslandsEmblem>(
              name: 'northern_mariana_islands_emblem',
              position: Vector2(37.29, 5.88),
              size: Vector2(53.42, 52.32),
              previousMustBePlaced: const ['1'],
            ),
            GroupedPathsPart(
              name: 'mariana_star',
              position: Vector2(51.04, 24),
              previousMustBePlaced: const ['northern_mariana_islands_emblem'],
              size: size,
              objects: (size) => [
                PathGameObject.fromSvgPath(
                  'm4.912 23.915 7.541-5.48 7.542 5.48-2.881-8.865 7.541-5.48-9.322.001-2.88-8.865-2.88 8.865H.25l7.542 5.479-2.881 8.865Z',
                  name: '',
                  areaSize: size,
                  position: (_) => Vector2(0, 0),
                  color: const Color(0xff000000),
                ),
                PathGameObject.fromSvgPath(
                  'm12.453 1.254 2.758 8.487h8.923l-7.22 5.244 2.758 8.486-7.219-5.245-7.219 5.245 2.758-8.486L.772 9.74h8.924l2.757-8.486Z',
                  name: '',
                  areaSize: size,
                  position: (_) => Vector2(0, 0),
                  color: const Color(0xffffffff),
                ),
              ],
            ),
          ],
        );
}
