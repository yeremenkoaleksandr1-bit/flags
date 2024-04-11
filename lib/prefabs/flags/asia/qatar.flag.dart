part of '../asia.dart';

class QatarFlag extends GameFlag {
  QatarFlag()
      : super(
          name: "Qatar",
          proportion: 11 / 28,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M0 64h47.787l13.032-3.556-13.032-3.555 13.032-3.556-13.032-3.555 13.032-3.556-13.032-3.555 13.032-3.556-13.032-3.555L60.819 32l-13.032-3.556 13.032-3.555-13.032-3.556 13.032-3.555-13.032-3.556 13.032-3.555L47.787 7.11l13.032-3.555L47.787 0H0v64Z",
              name: '1',
              color: const Color(0xFFffffff),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              "M115.122 0H0l13.033 3.556L0 7.11l13.033 3.556L0 14.222l13.033 3.556L0 21.333l13.033 3.556L0 28.444 13.033 32 0 35.556l13.033 3.555L0 42.667l13.033 3.555L0 49.778l13.033 3.555L0 56.89l13.033 3.555L0 64h115.122V0Z",
              name: '2',
              color: const Color(0xFF8A1538),
              areaSize: size,
              position: (_) => Vector2(48, 0),
            ),
          ],
        );
}
