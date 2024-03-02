part of '../europe.dart';

class FinlandFlag extends GameFlag {
  FinlandFlag()
      : super(
          name: "Finland",
          proportion: 11 / 18,
          objects: (size) => [
            PathPart(
              name: "1",
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M29.09 23.273V0h17.455v23.273h58.182v17.454H46.545V64H29.091V40.727H0V23.273h29.09Z",
              name: '2',
              areaSize: size,
              color: const Color(0xFF002F6C),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
