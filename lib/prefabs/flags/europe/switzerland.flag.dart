part of '../europe.dart';

class SwitzerlandFlag extends GameFlag {
  SwitzerlandFlag()
      : super(
          name: "Switzerland",
          proportion: 1,
          objects: (size) => [
            PathPart(
              name: "1",
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFDA291C),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M14.5 0h12v14h14v12h-14v14h-12V26H.5V14h14V0Z",
              name: "2",
              color: const Color(0xFFF4F5F0),
              position: (bounds) => Vector2(12, 12),
              areaSize: size,
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
