part of '../asia.dart';

class PakistanFlag extends GameFlag {
  PakistanFlag()
      : super(
          name: "Pakistan",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h24v64H0z",
              name: '1',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M72 0H0v64h72V0Z",
              name: '2',
              color: const Color(0xff01411C),
              areaSize: size,
              position: (_) => Vector2(24, 0),
            ),
            EmblemPart.fromType<PakistanEmblem>(
              position: Vector2(40.8, 13.71),
              size: Vector2(36.68, 37.49),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
