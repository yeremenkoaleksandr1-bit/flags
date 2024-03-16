part of '../asia.dart';

class PhilippinesFlag extends GameFlag {
  PhilippinesFlag()
      : super(
          name: "Philippines",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M128 0H0l55.425 32H128V0Z",
              name: '1',
              color: const Color(0xff0038A8),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M0 32h128V0H55.425L0 32Z",
              name: '2',
              color: const Color(0xffCE1126),
              areaSize: size,
              position: (_) => Vector2(0, 32),
            ),
            PathPart.fromSvgPath(
              "M55.425 32 0 64V0l55.425 32Z",
              name: '3',
              color: const Color(0xffffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M4.127 2.207 2.2.543l.478 2.5L.5 4.362l2.526.318.58 2.479 1.083-2.304 2.537.214-1.857-1.742L6.357.98l-2.23 1.227ZM48.025 27l-2.405.836-.052 2.545-1.538-2.029-2.437.738L43.047 27l-1.454-2.09 2.437.737 1.538-2.028.052 2.545 2.405.836ZM2.2 53.457l.478-2.5L.5 49.638l2.526-.318.58-2.48 1.083 2.305 2.537-.214-1.857 1.741.988 2.347-2.23-1.228L2.2 53.457Z",
              name: '4',
              color: const Color(0xffFCD116),
              areaSize: size,
              position: (_) => Vector2(1.5, 5),
              previousMustBePlaced: const ['3'],
            ),
            EmblemPart.fromType<PhilippinesEmblem>(
              position: Vector2(6.4, 18.49),
              size: Vector2(27.02, 27.02),
              previousMustBePlaced: const ['3'],
            ),
          ],
        );
}
