part of '../europe.dart';

class CroatiaFlag extends GameFlag {
  CroatiaFlag()
      : super(
          name: "Croatia",
          proportion: 1 / 2,
          objects: (size) {
            double totalFlex = 3;
            double unitHeight = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFF0000),
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
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              PathPart(
                name: "3",
                position: Vector2(0, unitHeight * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unitHeight).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF171796),
                  ),
                ),
              ),
              EmblemPart.fromType<CroatiaEmblem>(
                position: Vector2(49.09, 8.87),
                size: Vector2(29.82, 39.68),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
