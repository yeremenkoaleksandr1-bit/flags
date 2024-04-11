part of '../south_america.dart';

class ArgentinaFlag extends GameFlag {
  ArgentinaFlag()
      : super(
          name: "Argentina",
          proportion: 5 / 8,
          objects: (size) {
            double totalFlex = 3;
            double unit = size.y / totalFlex;

            return [
              PathGameObject(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF74ACDF),
                  ),
                  rect: Vector2(size.x, unit).toRect(),
                ),
              ),
              PathGameObject(
                name: '2',
                position: Vector2(0, unit),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              EmblemPart.fromType<ArgentinaEmblem>(
                position: Vector2(42.31, 23.11),
                size: Vector2(17.78, 17.78),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '1',
                position: Vector2(0, unit * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF74ACDF),
                  ),
                ),
              ),
            ];
          },
        );
}
