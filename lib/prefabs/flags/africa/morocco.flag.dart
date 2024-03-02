part of '../africa.dart';

class MoroccoFlag extends GameFlag {
  MoroccoFlag()
      : super(
          name: "Morocco",
          proportion: 2 / 3,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffC1272D),
            ),
            EmblemPart.fromType<MoroccoEmblem>(
              position: Vector2(31.21, 15.1),
              size: Vector2(33.58, 33.62),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
