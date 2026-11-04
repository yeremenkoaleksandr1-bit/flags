part of '../africa.dart';

class EquatorialGuineaFlag extends GameFlag {
  EquatorialGuineaFlag()
      : super(
          name: "Equatorial guinea",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF3E9A00),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<EquatorialGuineaEmblem>(
                position: Vector2(40.08, 22.56),
                size: Vector2(15.82, 18.89),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFE32118),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M0 0v64l24-32L0 0Z",
                name: '4',
                color: const Color(0xff0073CE),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
