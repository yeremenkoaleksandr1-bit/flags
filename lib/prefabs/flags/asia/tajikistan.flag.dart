part of '../asia.dart';

class TajikistanFlag extends GameFlag {
  TajikistanFlag()
      : super(
          name: "Tajikistan",
          proportion: 1 / 2,
          objects: (size) {
            return [
              PathPart.fromSvgPath(
                "M0 0h128v18.286H0V0Z",
                name: '1',
                color: const Color(0xFFCC0000),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathPart.fromSvgPath(
                "M-.004.276h128v27.438h-128V.276Z",
                name: '2',
                color: const Color(0xFFFFFFFF),
                areaSize: size,
                position: (_) => Vector2(0, 18),
              ),
              PathPart.fromSvgPath(
                "M0 .714h128V19H0V.714Z",
                name: '3',
                color: const Color(0xFF006600),
                areaSize: size,
                position: (_) => Vector2(0, 45),
              ),
              EmblemPart.fromType<TajikistanEmblem>(
                position: Vector2(49.07, 19.53),
                size: Vector2(29.95, 24.75),
                previousMustBePlaced: const ['2'],
              ),
            ];
          },
        );
}
