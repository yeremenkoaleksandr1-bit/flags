part of '../africa.dart';

class AngolaFlag extends GameFlag {
  AngolaFlag()
      : super(
          name: "Angola",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 2;
            double unitHeight = size.y / totalFlex;
            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCC092F),
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
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              EmblemPart.fromType<AngolaEmblem>(
                position: Vector2(34.2, 12.77),
                size: Vector2(30.56, 38.51),
                previousMustBePlaced: const ['1', '2'],
              )
            ];
          },
        );
}
