part of '../africa.dart';

class MauritiusFlag extends GameFlag {
  MauritiusFlag()
      : super(
          name: "Mauritius",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 4;
            double unitHeight = size.y / totalFlex;
            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFEA2839),
                  ),
                  rect: Vector2(size.x, unitHeight).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                position: Vector2(0, unitHeight),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF1A206D),
                  ),
                ),
              ),
              PathGameObject(
                name: '3',
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFD500),
                  ),
                ),
              ),
              PathGameObject(
                name: '4',
                position: Vector2(0, unitHeight * 3),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00A551),
                  ),
                ),
              ),
            ];
          },
        );
}
