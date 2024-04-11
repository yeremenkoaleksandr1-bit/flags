part of '../africa.dart';

class MaliFlag extends GameFlag {
  MaliFlag()
      : super(
          name: "Mali",
          proportion: 2 / 3,
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
                    color: const Color(0xFF14B53A),
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
                    color: const Color(0xFFFCD116),
                  ),
                ),
              ),
              PathGameObject(
                name: "3",
                position: Vector2((unitWidth) * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCE1126),
                  ),
                ),
              ),
            ];
          },
        );
}
