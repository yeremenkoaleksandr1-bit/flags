part of '../europe.dart';

class AndorraFlag extends GameFlag {
  AndorraFlag()
      : super(
          name: "Andorra",
          proportion: 7 / 10,
          objects: (size) {
            double totalFlex = 3;
            double unitWidth = size.x / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF10069F),
                  ),
                  rect: Vector2(unitWidth, size.y).toRect(),
                ),
              ),
              PathPart(
                name: "2",
                position: Vector2(unitWidth, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFEDD00),
                  ),
                ),
              ),
              EmblemPart.fromType<AndorraEmblem>(
                position: Vector2(32, 17.23),
                size: Vector2(27.38, 29.54),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: "3",
                position: Vector2(unitWidth * 2, 0),
                path: SPath.rect(
                  rect: Vector2(unitWidth, size.y).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFD52B1E),
                  ),
                ),
              ),
            ];
          },
        );
}
