part of '../africa.dart';

class EthiopiaFlag extends GameFlag {
  EthiopiaFlag()
      : super(
          name: "Ethiopia",
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
                    color: const Color(0xFF078930),
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
                    color: const Color(0xFFFCDD09),
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
                    color: const Color(0xFFDA121A),
                  ),
                ),
              ),
              EmblemPart.fromType<EthiopiaEmblem>(
                position: Vector2(42.67, 10.67),
                size: Vector2(42.67, 42.67),
                previousMustBePlaced: const ['1', '2', '3'],
              ),
            ];
          },
        );
}
