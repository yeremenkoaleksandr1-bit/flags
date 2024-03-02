part of '../africa.dart';

class BurkinaFasoFlag extends GameFlag {
  BurkinaFasoFlag()
      : super(
          name: "Burkina faso",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 2;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFEF2B2D),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF009E49),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "m.855 7.605 6.27 4.555-2.395 7.37L11 14.976l6.27 4.556-2.395-7.37 6.27-4.556h-7.75L11 .235l-2.395 7.37H.855Z",
                name: '3',
                color: const Color(0xffFCD116),
                areaSize: size,
                position: (_) => Vector2(37.86, 21.33),
                previousMustBePlaced: const ['1', '2'],
              ),
            ];
          },
        );
}
