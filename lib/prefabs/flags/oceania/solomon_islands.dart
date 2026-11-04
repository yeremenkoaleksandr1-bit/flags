part of '../oceania.dart';

class SolomonIslandFlag extends GameFlag {
  SolomonIslandFlag()
      : super(
          name: "Solomon Island",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff0051BA),
            ),
            PathGameObject.fromSvgPath(
              "M128 0v64H0L128 0Z",
              name: '2',
              areaSize: size,
              color: const Color(0xff215B33),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "m29.71 8.127-3.762-2.734h4.65L32.035.971l1.436 4.422h4.65L34.36 8.126l1.437 4.423-3.761-2.733-3.762 2.733 1.437-4.422ZM4.435 8.115.673 5.382h4.65L6.76.96l1.436 4.422h4.65L9.084 8.115l1.437 4.422L6.76 9.804l-3.762 2.733 1.437-4.422ZM17.08 18.956l-3.762-2.734h4.65l1.437-4.422 1.437 4.422h4.65l-3.762 2.733 1.437 4.423-3.762-2.733-3.762 2.733 1.437-4.422ZM4.435 29.784.673 27.051h4.65L6.76 22.63l1.436 4.422h4.65l-3.762 2.733 1.437 4.423-3.761-2.733-3.762 2.733 1.437-4.423Zm25.275 0-3.762-2.733h4.65l1.437-4.422 1.436 4.422h4.65l-3.762 2.733 1.437 4.423-3.761-2.733-3.762 2.733 1.437-4.423Z",
              name: '3',
              areaSize: size,
              color: const Color(0xffffffff),
              position: (_) => Vector2(3.67, 1.96),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M128 3.343 6.447 64.119H0V60.89L121.542.12H128v3.223Z",
              name: '4',
              areaSize: size,
              previousMustBePlaced: const ['2'],
              color: const Color(0xffFCD116),
            ),
          ],
        );
}
