part of '../north_america.dart';

class DominicanRepublicFlag extends GameFlag {
  DominicanRepublicFlag()
      : super(
          name: "Dominican republic",
          proportion: 2 / 3,
          objects: (size) {
            final path = parseSvgPathModel("M0 0h41.6v25.6H0V0Z");
            return [
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF002D62),
                  ),
                ),
                name: '1',
                position: Vector2(0, 0),
              ),
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFF002D62),
                  ),
                ),
                name: '1',
                position: Vector2(54.4, 38.4),
              ),
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFCE1126),
                  ),
                ),
                name: '2',
                position: Vector2(54.4, 0),
              ),
              PathPart(
                path: path.copyWith(
                  paint: SPaint(
                    color: const Color(0xFFCE1126),
                  ),
                ),
                name: '2',
                position: Vector2(0, 38.4),
              ),
              PathPart.fromSvgPath(
                "M54.4 0H41.6v25.6H0v12.8h41.6V64h12.8V38.4H96V25.6H54.4V0Z",
                name: '3',
                color: const Color(0xFFFFFFFF),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              EmblemPart.fromType<DominicanRepublicEmblem>(
                position: Vector2(41.6, 25.6),
                size: Vector2(12.8, 12.8),
                previousMustBePlaced: const ['3'],
              ),
            ];
          },
        );
}
