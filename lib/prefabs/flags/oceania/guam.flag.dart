part of '../oceania.dart';

class GuamFlag extends GameFlag {
  GuamFlag()
      : super(
          name: "Guam",
          proportion: 22 / 41,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff00297B),
            ),
            PathGameObject.fromSvgPath(
              "M.2.096h119.273V64.09H.2V.096Zm2.908 2.928v58.16h113.454V3.024H3.108Z",
              name: '2',
              areaSize: size,
              color: const Color(0xffC62139),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<GuamEmblem>(
              position: Vector2(48.64, 15.51),
              size: Vector2(21.99, 32.98),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
