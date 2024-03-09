part of '../europe.dart';

class NorwayFlag extends GameFlag {
  NorwayFlag()
      : super(
          name: "Norway",
          proportion: 8 / 11,
          objects: (size) => [
            PathPart(
              name: "1",
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFBA0C2F),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M24 24V0h16v24h48v16H40v24H24V40H0V24h24Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffFFFFFF),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M28 28V0h8v28h52v8H36v28h-8V36H0v-8h28Z",
              name: '3',
              areaSize: size,
              color: const Color(0xff00205B),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
