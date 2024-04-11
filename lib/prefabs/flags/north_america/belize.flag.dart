part of '../north_america.dart';

class BelizeFlag extends GameFlag {
  BelizeFlag()
      : super(
          name: "Belize",
          proportion: 3 / 5,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 0h106.667v6.4H0V0Z",
              name: '1',
              uniqueName: "1_1",
              color: const Color(0xFFD90F19),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v51.2H0V0Z",
              name: '2',
              color: const Color(0xFF171696),
              areaSize: size,
              position: (_) => Vector2(0, 6.4),
            ),
            EmblemPart.fromType<BelizeEmblem>(
              position: Vector2(34.67, 13.33),
              size: Vector2(37.33, 37.33),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              "M0 0h106.667v6.4H0V0Z",
              name: '1',
              uniqueName: "1_2",
              color: const Color(0xFFD90F19),
              areaSize: size,
              position: (_) => Vector2(0, 57.6),
            ),
          ],
        );
}
