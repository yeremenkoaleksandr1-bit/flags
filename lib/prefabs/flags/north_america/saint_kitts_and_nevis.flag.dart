part of '../north_america.dart';

class SaintKittsAndNevisFlag extends GameFlag {
  SaintKittsAndNevisFlag()
      : super(
          name: "Saint Kitts and Nevis",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              'M0 0v47.847L71.77 0H0Z',
              name: '1',
              color: const Color(0xFF009739),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              'M71.77 0H96v16.153L24.23 64H0V47.847L71.77 0Z',
              name: '2',
              color: const Color(0xFFFFCD00),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathGameObject.fromSvgPath(
              'M0 47.847h71.77V0L0 47.847Z',
              name: '3',
              color: const Color(0xFFC8102E),
              areaSize: size,
              position: (_) => Vector2(24.23, 16.15),
            ),
            PathGameObject.fromSvgPath(
              'M78.693 0H96v11.538L17.307 64H0V52.462L78.693 0Z',
              name: '4',
              color: const Color(0xFF000000),
              areaSize: size,
              position: (_) => Vector2(0, 0),
              previousMustBePlaced: const ['2'],
            ),
            PathGameObject.fromSvgPath(
              'M8.764 4.036 3.656 0l1.76 6.268L0 9.879l6.504.262 1.761 6.267 2.26-6.105 6.504.262-5.108-4.036L14.18.425l-5.416 3.61Z',
              name: '5',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(21.39, 37.56),
              previousMustBePlaced: const ['4'],
            ),
            PathGameObject.fromSvgPath(
              'M8.764 4.036 3.656 0l1.76 6.268L0 9.879l6.504.262 1.761 6.267 2.26-6.105 6.504.262-5.108-4.036L14.18.425l-5.416 3.61Z',
              name: '5',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(58.31, 12.95),
              previousMustBePlaced: const ['4'],
            ),
          ],
        );
}
