part of '../europe.dart';

class NorthMacedoniaFlag extends GameFlag {
  NorthMacedoniaFlag()
      : super(
          name: "North Macedonia",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart(
              name: "1",
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFD82126),
                ),
              ),
            ),
            PathPart.fromSvgPath(
              "M0 25.6v12.8l52.627-5.263a11.584 11.584 0 0 1 0-2.274L0 25.6Zm53.601 11.147L0 64h19.2l35.728-25.048a11.425 11.425 0 0 1-1.327-2.205Zm9.249 6.624a11.574 11.574 0 0 0 2.3 0L70.4 64H57.6l5.25-20.629Zm10.222-4.419c.52-.679.967-1.418 1.327-2.205L128 64h-19.2L73.072 38.952Zm2.301-5.815L128 38.4V25.6l-52.627 5.263a11.553 11.553 0 0 1 0 2.274Zm-.973-5.884L128 0h-19.2L73.072 25.048c.52.679.967 1.418 1.327 2.205Zm-19.472-2.205a11.425 11.425 0 0 0-1.327 2.205L0 0h19.2l35.728 25.048Zm10.222-4.42a11.542 11.542 0 0 0-2.3 0L57.6 0h12.8l-5.25 20.628Z",
              name: '2',
              position: (bounds) => Vector2(
                size.x / 2 - bounds.width / 2,
                size.y / 2 - bounds.height / 2,
              ),
              areaSize: size,
              color: const Color(0xffF8E92E),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M18.286 9.143A9.143 9.143 0 1 1 0 9.143a9.143 9.143 0 0 1 18.286 0Z",
              name: '3',
              position: (bounds) => Vector2(
                size.x / 2 - bounds.width / 2,
                size.y / 2 - bounds.height / 2,
              ),
              areaSize: size,
              color: const Color(0xffF8E92E),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
