part of '../africa.dart';

class MauritaniaFlag extends GameFlag {
  MauritaniaFlag()
      : super(
          name: "Mauritania",
          proportion: 2 / 3,
          objects: (size) {
            return [
              PathPart.fromSvgPath(
                "M0 0h96v12.8H0V0Z",
                name: '1',
                color: const Color(0xffD01C1F),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathPart.fromSvgPath(
                "M0 .8h96v38.4H0V.8Z",
                name: '2',
                color: const Color(0xff00A95C),
                areaSize: size,
                position: (_) => Vector2(0, 12),
              ),
              EmblemPart.fromType<MauritaniaEmblem>(
                position: Vector2(24.4, 19.2),
                size: Vector2(48, 25.6),
                previousMustBePlaced: const ['2'],
              ),
              PathPart.fromSvgPath(
                "M0 0h96v12.8H0V0Z",
                name: '1',
                color: const Color(0xffD01C1F),
                areaSize: size,
                position: (_) => Vector2(0, 51.2),
              ),
            ];
          },
        );
}
