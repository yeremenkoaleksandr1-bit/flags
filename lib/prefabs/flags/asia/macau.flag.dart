part of '../asia.dart';

class MacauFlag extends GameFlag {
  MacauFlag()
      : super(
          name: "Macau",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff0F7562),
            ),
            EmblemPart.fromType<MacauEmblem>(
              position: Vector2(31.81, 11.9),
              size: Vector2(32.43, 37.97),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
