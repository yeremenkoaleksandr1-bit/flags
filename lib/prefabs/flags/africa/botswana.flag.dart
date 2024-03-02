part of '../africa.dart';

class BotswanaFlag extends GameFlag {
  BotswanaFlag()
      : super(
          name: "Botswana",
          proportion: 2 / 3,
          objects: (size) {
            return [
              PathPart.fromSvgPath(
                "M.0 0h96v24h-96V0Z",
                name: '1',
                color: const Color(0xff6DA9D2),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathPart.fromSvgPath(
                "M96.0 0h-96v2.667h96V0Z",
                name: '2',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(0, 24),
              ),
              PathPart.fromSvgPath(
                "M96.0.0h-96v10.666h96V.667Z",
                name: '3',
                color: const Color(0xff000000),
                areaSize: size,
                position: (_) => Vector2(0, 26.67),
              ),
              PathPart.fromSvgPath(
                "M96.0 0h-96v2.667h96V0Z",
                name: '2',
                color: const Color(0xffffffff),
                areaSize: size,
                position: (_) => Vector2(0, 37.33),
              ),
              PathPart.fromSvgPath(
                "M.0 0h96v24h-96V0Z",
                name: '1',
                color: const Color(0xff6DA9D2),
                areaSize: size,
                position: (_) => Vector2(0, 40),
              ),
            ];
          },
        );
}
