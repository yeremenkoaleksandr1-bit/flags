part of '../oceania.dart';

class NiueFlag extends GameFlag {
  NiueFlag()
      : super(
          name: "Niue",
          proportion: 1 / 2,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffFEDD00),
            ),
            GroupedPathsPart(
              name: 'flag_uk',
              position: Vector2.zero(),
              size: Vector2(64, 32),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathPart.rect(
                  name: "1",
                  size: visualSize,
                  color: const Color(0xFF012169),
                  position: Vector2.zero(),
                ),
                PathPart.fromSvgPath(
                  "M0 3.578 24.845 16 0 28.422V32h7.155L32 19.578 56.844 32H64v-3.578L39.155 16 64 3.578V0h-7.156L32 12.422 7.155 0H0v3.578Z",
                  name: '2',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "M0 2.385 27.23 16H32L0 32h4.77L32 18.385V16l32 16v-2.385L36.77 16H32L64 0h-4.77L32 13.615V16L0 0v2.385Z",
                  name: '3',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "M0 10.707v10.706h26.667V32.01h10.666V21.413H64V10.707H37.333V0H26.667v10.707H0Z",
                  name: '4',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  "M0 12.8v6.4h28.8V32h6.4V19.2H64v-6.4H35.2V0h-6.4v12.8H0Z",
                  name: '5',
                  color: const Color(0xFFC8102E),
                  areaSize: size,
                ),
                PathPart.fromSvgPath(
                  'M6 11.5A5.444 5.444 0 1 0 6 .61 5.444 5.444 0 0 0 6 11.5Z',
                  name: 'circle',
                  areaSize: size,
                  position: (_) => Vector2(26.15, 9.8),
                  color: const Color(0xff012169),
                ),
                PathPart.fromSvgPath(
                  'm40.665 11.098.72 2.214h2.327L41.83 14.68l.72 2.214-1.884-1.368-1.883 1.368.72-2.214-1.884-1.368h2.328l.719-2.214ZM22.001.439l.72 2.214h2.328L23.165 4.02l.72 2.214L22 4.866l-1.883 1.369.72-2.214-1.884-1.368h2.328l.72-2.214ZM3.335 11.105l.72 2.214h2.327l-1.883 1.369.72 2.213-1.884-1.368-1.884 1.368.72-2.213-1.883-1.369h2.328l.719-2.214Zm18.659 10.66.72 2.214h2.327l-1.883 1.368.72 2.214-1.884-1.368-1.883 1.368.72-2.214-1.884-1.368h2.328l.719-2.214Zm.007-13.213 1.223 3.762h3.955l-3.2 2.325 1.222 3.762-3.2-2.325-3.2 2.325 1.223-3.762-3.2-2.325h3.955l1.222-3.762Z',
                  name: 'stars',
                  areaSize: size,
                  position: (_) => Vector2(10.2, 1.8),
                  color: const Color(0xffFEDD00),
                ),
              ],
            ),
          ],
        );
}
