part of '../europe.dart';

class MoldovaFlag extends GameFlag {
  MoldovaFlag()
      : super(
          name: "Moldova",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF0046AE),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFD200),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCC092F),
                  ),
                ),
              ),
              EmblemPart.fromType<MoldovaEmblem>(
                position: Vector2(50.04, 13.03),
                size: Vector2(28.46, 35.84),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
