part of '../africa.dart';

class EswatiniFlag extends GameFlag {
  EswatiniFlag()
      : super(
          name: "Eswatini",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h96v12H0V0Z",
              name: '1',
              color: const Color(0xff3E5EB9),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v4H0V0Z",
              name: '2',
              color: const Color(0xffFFD900),
              areaSize: size,
              position: (_) => Vector2(0, 12),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v32H0V0Z",
              name: '3',
              color: const Color(0xffB10C0C),
              areaSize: size,
              position: (_) => Vector2(0, 16),
            ),
            EmblemPart.fromType<EswatiniEmblem>(
              position: Vector2(9.57, 18.29),
              size: Vector2(77.71, 27.43),
              previousMustBePlaced: const ['3'],
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v4H0V0Z",
              name: '2',
              color: const Color(0xffFFD900),
              areaSize: size,
              position: (_) => Vector2(0, 48),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h96v12H0V0Z",
              name: '1',
              color: const Color(0xff3E5EB9),
              areaSize: size,
              position: (_) => Vector2(0, 52),
            ),
          ],
        );
}
