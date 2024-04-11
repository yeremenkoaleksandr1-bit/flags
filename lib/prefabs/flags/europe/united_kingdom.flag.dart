part of '../europe.dart';

class UnitedKingdomFlag extends GameFlag {
  UnitedKingdomFlag()
      : super(
          name: "United Kingdom",
          proportion: 1 / 2,
          objects: (size) {
            return [
              PathGameObject(
                name: "1",
                path: SPath.rect(
                  rect: size.toRect(),
                  paint: SPaint(
                    style: PaintingStyle.fill,
                    color: const Color(0xFF012169),
                  ),
                ),
              ),
              PathGameObject(
                name: '2',
                path: parseSvgPathModel(
                  "M49.69 32-2.863 5.724 2.862-5.724 64 24.845l61.138-30.57 5.724 11.45L78.311 32l52.551 26.276-5.724 11.448L64 39.155 2.862 69.725l-5.724-11.45L49.689 32Z",
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                position: Vector2(0, 0),
                previousMustBePlaced: const ['1'],
              ),
              PathGameObject(
                name: '3',
                path: parseSvgPathModel(
                  "M54.46 32 0 4.77V0l59.23 29.615L64 27.23 118.459 0H128L68.77 29.615 73.54 32 128 59.23V64L68.77 34.385 64 36.77 9.54 64H0l59.23-29.615L54.46 32Z",
                  paint: SPaint(
                    color: const Color(0xFFC8102E),
                  ),
                ),
                position: Vector2(0, 0),
                previousMustBePlaced: const ['2'],
              ),
              PathGameObject(
                name: '4',
                path: parseSvgPathModel(
                  "M53.333 21.333V0h21.334v21.333H128v21.334H74.667V64H53.333V42.667H0V21.333h53.333Z",
                  paint: SPaint(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                position: Vector2(0, 0),
                previousMustBePlaced: const ['3'],
              ),
              PathGameObject(
                name: '5',
                path: parseSvgPathModel(
                  "M57.6 25.6V0h12.8v25.6H128v12.8H70.4V64H57.6V38.4H0V25.6h57.6Z",
                  paint: SPaint(
                    color: const Color(0xFFC8102E),
                  ),
                ),
                position: Vector2(0, 0),
                previousMustBePlaced: const ['4'],
              ),
            ];
          },
        );
}
