part of '../asia.dart';

class TurkmenistanFlag extends GameFlag {
  TurkmenistanFlag()
      : super(
          name: "Turkmenistan",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff00843D),
            ),
            EmblemPart.fromType<TurkmenistanEmblem>(
              position: Vector2(34.56, 6.08),
              size: Vector2(17.93, 16.3),
              previousMustBePlaced: const ['1'],
            ),
            EmblemPart.fromType<TurkmenistanPattern>(
              position: Vector2(12, 0),
              size: Vector2(17.28, 64),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
