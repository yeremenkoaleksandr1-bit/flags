part of '../asia.dart';

class UnitedArabEmiratesFlag extends GameFlag {
  UnitedArabEmiratesFlag()
      : super(
          name: "United Arab Emirates",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M96 0H0v21.334h96V0Z",
              name: '1',
              color: const Color(0xff00732F),
              areaSize: size,
              position: (_) => Vector2(32, 0),
            ),
            PathGameObject.fromSvgPath(
              "M96 .333H0v21.334h96V.333Z",
              name: '2',
              color: const Color(0xffFFFFFF),
              areaSize: size,
              position: (_) => Vector2(32, 21),
            ),
            PathGameObject.fromSvgPath(
              "M96 .667H0V22h96V.667Z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(32, 42),
            ),
            PathGameObject.fromSvgPath(
              "M32 0H0v64h32V0Z",
              name: '4',
              color: const Color(0xffFF0000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
          ],
        );
}
