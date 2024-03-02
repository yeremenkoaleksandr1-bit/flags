part of '../europe.dart';

class DenmarkFlag extends GameFlag {
  DenmarkFlag()
      : super(
          name: "Denmark",
          proportion: 28 / 37,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFC8102E),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M27.429 27.429V0h9.142v27.429h48v9.142h-48V64H27.43V36.571H0V27.43h27.429Z",
              name: "2",
              areaSize: size,
              color: const Color(0xFFFFFFFF),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
