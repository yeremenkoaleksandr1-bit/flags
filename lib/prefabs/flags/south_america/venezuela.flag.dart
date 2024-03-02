part of '../south_america.dart';

class VenezuelaFlag extends GameFlag {
  VenezuelaFlag()
      : super(
          name: "Venezuela",
          proportion: 2 / 3,
          objects: (size) {
            double totalFlex = 3;
            double unit = size.y / totalFlex;

            return [
              PathPart(
                name: '1',
                path: SPath.rect(
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFFFCC00),
                  ),
                  rect: Vector2(size.x, unit).toRect(),
                ),
              ),
              PathPart(
                name: '2',
                position: Vector2(0, unit),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF00247D),
                  ),
                ),
              ),
              PathPart.fromSvgPath(
                "m14.468 2.342 1.982-.35L16.73 0l.944 1.776 1.981-.349-1.397 1.447.944 1.777-1.808-.882-1.398 1.447.28-1.992-1.808-.882ZM8.438 5.45l1.743-1.007-.419-1.967 1.495 1.346L13 2.816l-.819 1.838L13.677 6l-2.001-.21-.819 1.838-.418-1.968-2-.21Zm-1.152.93L5.887 7.826 4.08 6.942l.942 1.777-1.399 1.446 1.982-.347.942 1.777.283-1.992 1.981-.347-1.807-.884.282-1.992Zm-4.587 5.066-.688 1.89L0 13.266l1.585 1.239-.688 1.89 1.668-1.125 1.586 1.239-.555-1.934 1.668-1.125-2.01-.07-.555-1.934Zm35.859 3.824 1.668 1.125-.688-1.89 1.585-1.239-2.01.07-.688-1.89-.555 1.934-2.01.07 1.667 1.125-.554 1.934 1.585-1.239Zm-3.04-5.452 1.982.347-1.4-1.446.943-1.777-1.807.884-1.4-1.446.283 1.992-1.807.884 1.982.347.282 1.992.942-1.777ZM30.684 5.66l2.001-.21-1.742-1.007.418-1.967-1.495 1.346-1.742-1.006.818 1.838L27.447 6l2-.21.819 1.838.418-1.968Zm-5.837-2.436 1.808-.882-1.981-.35L24.394 0l-.945 1.776-1.981-.349 1.398 1.447-.945 1.777 1.808-.882 1.398 1.447-.28-1.992Z",
                name: '',
                color: const Color(0xFFFFFFFF),
                areaSize: size,
                position: (_) => Vector2(27.44, 23.75),
                previousMustBePlaced: const ['2'],
              ),
              PathPart(
                name: '3',
                position: Vector2(0, unit * 2),
                path: SPath.rect(
                  rect: Vector2(size.x, unit).toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFFCF142B),
                  ),
                ),
              ),
            ];
          },
        );
}
