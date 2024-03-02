part of '../asia.dart';

class BruneiFlag extends GameFlag {
  BruneiFlag()
      : super(
          name: "Brunei",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffF7E017),
            ),
            PathPart.fromSvgPath(
              "M-.072 15.556V.444l128 26.667v15.111l-128-26.666Z",
              name: '2',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 4.44),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M0 .556v13.333l128 26.667V27.222L0 .556Z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(0, 19.56),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<BruneiEmblem>(
              position: Vector2(42.65, 13.25),
              size: Vector2(42.7, 37.5),
              previousMustBePlaced: const ['1', '2', '3'],
            ),
          ],
        );
}
