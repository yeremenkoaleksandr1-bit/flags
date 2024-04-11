part of '../oceania.dart';

class WallisAndFutunaFlag extends GameFlag {
  WallisAndFutunaFlag()
      : super(
          name: "Wallis and Futuna",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffCE1126),
            ),
            PathGameObject.fromSvgPath(
              "M10.655 8.44 2.975.76h15.36l-7.68 7.68ZM8.095 11 .415 3.32v15.36L8.095 11Zm2.56 2.56-7.68 7.68h15.36l-7.68-7.68Zm2.56-2.56 7.68-7.68v15.36L13.215 11Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffffffff),
              position: (_) => Vector2(56, 21),
              previousMustBePlaced: const ['1'],
            ),
            GroupedPathsPart(
              name: '3',
              position: Vector2(-1, 0),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathGameObject.fromSvgPath(
                  "M.455 0h39.03v25.891H.455z",
                  name: '',
                  areaSize: size,
                  color: const Color(0xffffffff),
                ),
                PathGameObject.fromSvgPath(
                  "M.455 0h12.8v25.282H.455z",
                  name: '',
                  areaSize: size,
                  position: (bounds) => Vector2(0, 0),
                  color: const Color(0xff002654),
                ),
                PathGameObject.fromSvgPath(
                  "M.255 0h12.8v25.282H.255z",
                  name: '',
                  areaSize: size,
                  position: (bounds) => Vector2(12.8, 0),
                  color: const Color(0xffffffff),
                ),
                PathGameObject.fromSvgPath(
                  "M.055 0h12.8v25.282H.055z",
                  name: '',
                  areaSize: size,
                  position: (bounds) => Vector2(25.6, 0),
                  color: const Color(0xffCE1126),
                ),
              ],
            ),
          ],
        );
}
