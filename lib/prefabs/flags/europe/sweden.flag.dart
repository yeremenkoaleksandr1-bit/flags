part of '../europe.dart';

class SwedenFlag extends GameFlag {
  SwedenFlag()
      : super(
          name: "Sweden",
          proportion: 5 / 8,
          objects: (size) => [
            PathPart(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF006AA7),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M32 0h12.8v25.6h57.6v12.8H44.8V64H32V38.4H0V25.6h32V0Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffFECC00),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
