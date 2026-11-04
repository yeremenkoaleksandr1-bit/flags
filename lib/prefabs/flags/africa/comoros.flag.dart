part of '../africa.dart';

class ComorosFlag extends GameFlag {
  ComorosFlag()
      : super(
          name: "Comoros",
          proportion: 3 / 5,
          objects: (size) {
            double totalFlex = 4;
            double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFD100),
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
                    color: const Color(0xFFffffff),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFEF3340),
                  ),
                ),
              ),
              PathGameObject(
                name: "4",
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF003DA5),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M53.333 32 0 64V0l53.333 32Z",
                name: '5',
                color: const Color(0xff009639),
                areaSize: size,
                position: (_) => Vector2(0, 0),
                previousMustBePlaced: const ['1', '2', '3', '4'],
              ),
              EmblemPart.fromType<ComorosEmblem>(
                position: Vector2(3.11, 16.89),
                size: Vector2(22.11, 30.22),
                previousMustBePlaced: const ['5'],
              )
            ];
          },
        );
}
