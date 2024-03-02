part of '../oceania.dart';

class SamoaFlag extends GameFlag {
  SamoaFlag()
      : super(
          name: "Samoa",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffCE1126),
            ),
            PathPart.fromSvgPath(
              "M.478 0h64v32h-64V0Z",
              name: '2',
              color: const Color(0xFF002B7F),
              areaSize: size,
              position: (_) => Vector2(-1, 0),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "m13.478.333.84 2.584h2.716l-2.198 1.596.84 2.583L13.477 5.5 11.28 7.096l.84-2.583-2.198-1.596h2.717l.839-2.584Zm-9.778 8 .84 2.584h2.716l-2.198 1.596.84 2.583L3.7 13.5l-2.197 1.596.84-2.583-2.198-1.596H2.86l.84-2.584Zm14.667 6.885.524 1.614h1.698l-1.373.998.524 1.615-1.373-.998-1.374.998.525-1.615-1.373-.998h1.697l.525-1.614Zm-4.889 5.995 1.049 3.229h3.395l-2.747 1.995 1.05 3.23-2.747-1.996-2.747 1.996 1.05-3.23-2.748-1.995h3.396l1.049-3.23ZM23.478 7l.787 2.422h2.546l-2.06 1.496.787 2.422-2.06-1.497-2.06 1.497.787-2.421-2.06-1.497h2.546L23.478 7Z",
              name: '3',
              color: const Color(0xFFffffff),
              areaSize: size,
              position: (_) => Vector2(18.67, 1),
              previousMustBePlaced: const ['2'],
            ),
          ],
        );
}
