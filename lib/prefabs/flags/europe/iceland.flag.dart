part of '../europe.dart';

class IcelandFlag extends GameFlag {
  IcelandFlag()
      : super(
          name: "Iceland",
          proportion: 18 / 25,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF02529C),
                ),
              ),
            ),
            PathGameObject.fromSvgPath(
              "M24.889 24.889V0H39.11v24.889h49.78V39.11H39.11V64H24.89V39.111H0V24.89h24.889Z",
              name: '2',
              areaSize: size,
              color: const Color(0xFFFFFFFF),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M28.444 28.444V0h7.112v28.444h53.333v7.112H35.556V64h-7.112V35.556H0v-7.112h28.444Z",
              name: '3',
              areaSize: size,
              color: const Color(0xFFDC1E35),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
