part of '../europe.dart';

class AzerbaijanFlag extends GameFlag {
  AzerbaijanFlag()
      : super(
          name: "Azerbaijan",
          proportion: 1 / 2,
          objects: (size) {
            const double totalFlex = 3;
            final double unitHeight = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    color: const Color(0xFF00B5E2),
                  ),
                ),
              ),
              PathGameObject(
                name: "2",
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    color: const Color(0xFFEF3340),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    color: const Color(0xFF509E2F),
                  ),
                ),
              ),
              EmblemPart.fromType<AzerbaijanEmblem>(
                position: Vector2(51.2, 22.4),
                size: Vector2(25.6, 19.2),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
