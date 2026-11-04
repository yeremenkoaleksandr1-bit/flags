part of '../africa.dart';

class SenegalFlag extends GameFlag {
  SenegalFlag()
      : super(
          name: "Senegal",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00853F),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFDEF42),
                  ),
                ),
              ),
              PathGameObject.fromSvgPath(
                "M13.396 7.814 11 .44 8.604 7.814H.85l6.273 4.558-2.396 7.375L11 15.189l6.273 4.558-2.396-7.375 6.273-4.558h-7.754Z",
                name: '4',
                color: const Color(0xFF00853F),
                areaSize: size,
                position: (_) => Vector2(37.83, 21.41),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: "3",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFE31B23),
                  ),
                ),
              ),
            ];
          },
        );
}
