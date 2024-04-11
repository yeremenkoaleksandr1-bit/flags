part of '../north_america.dart';

class NicaraguaFlag extends GameFlag {
  NicaraguaFlag()
      : super(
          name: "Nicaragua",
          proportion: 3 / 5,
          objects: (size) {
            double totalFlex = 3;
            double unitFlex = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF17C0EB),
                  ),
                  rect: Vector2(size.x, unitFlex).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                position: Vector2(0, unitFlex),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<NicaraguaEmblem>(
                position: Vector2(43.73, 22.4),
                size: Vector2(19.2, 19.2),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '1',
                position: Vector2(0, unitFlex * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitFlex).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF17C0EB),
                  ),
                ),
              ),
            ];
          },
        );
}
