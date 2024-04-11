part of '../europe.dart';

class MontenegroFlag extends GameFlag {
  MontenegroFlag()
      : super(
          name: "Montenegro",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFE30613),
                ),
              ),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h128v64H0V0Zm3.2 3.2v57.6h121.6V3.2H3.2Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffE9B528),
              previousMustBePlaced: const ["1"],
            ),
            EmblemPart.fromType<MontenegroEmblem>(
              position: Vector2(45.5, 10.67),
              size: Vector2(36.99, 42.67),
              previousMustBePlaced: const ["1"],
            ),
          ],
        );
}
