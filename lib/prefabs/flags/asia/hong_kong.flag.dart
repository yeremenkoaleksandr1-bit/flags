part of '../asia.dart';

class HongKongFlag extends GameFlag {
  HongKongFlag()
      : super(
          name: "Hong Kong",
          proportion: 2 / 3,
          objects: (size) {
            final starPath = parseSvgPathModel(
              "m2.142 1.195 1.123-.49-.62 1.057.813.916-1.197-.263-.62 1.056-.12-1.22-1.196-.263 1.123-.49L1.33.278l.813.917Z",
              paint: SPaint(
                color: const Color(0xffEE1C25),
              ),
            );

            return [
              PathGameObject.rect(
                name: '1',
                position: Vector2.zero(),
                size: size,
                color: const Color(0xffEE1C25),
              ),
              GroupedPathsPart(
                name: '2',
                position: Vector2(30.65, 13.24),
                size: Vector2(36.5, 36.54),
                previousMustBePlaced: const ['1'],
                objects: (visualSize) => [
                  PathGameObject.rect(
                    name: "",
                    size: visualSize,
                    color: ThemePalette.transparent,
                    position: Vector2.zero(),
                  ),
                  PathGameObject.fromSvgPath(
                    "M7.309 19.164a2.979 2.979 0 0 0-1.335-4.54 4.818 4.818 0 0 1-2.4-6.986A4.123 4.123 0 0 0 .476 1.41a7.293 7.293 0 0 1 7.36 7.034c.055.004.109.011.162.02A7.454 7.454 0 0 0 .546 1.25 9.636 9.636 0 0 1 7.31 19.164Z",
                    name: '',
                    areaSize: size,
                    position: (bounds) => Vector2(17.78, 18.33),
                    color: const Color(0xffFFFFFF),
                  ),
                  PathGameObject.fromSvgPath(
                    "M1.736.27a2.978 2.978 0 0 0 3.749 2.889 4.818 4.818 0 0 1 6.047 4.24 4.124 4.124 0 0 0 6.168 3.218A7.294 7.294 0 0 1 7.61 9.252a1.687 1.687 0 0 1-.143.078 7.454 7.454 0 0 0 10.27 1.458A9.637 9.637 0 0 1 1.737.27Z",
                    name: '',
                    areaSize: size,
                    position: (bounds) => Vector2(-0.4, 8.8),
                    color: const Color(0xffFFFFFF),
                  ),
                  PathGameObject.fromSvgPath(
                    "M11.635.743a2.977 2.977 0 0 0-1.59 4.457 4.817 4.817 0 0 1-2.164 7.062 4.122 4.122 0 0 0-1.154 6.86 7.293 7.293 0 0 1-1.82-10.017 1.685 1.685 0 0 1-.119-.112 7.454 7.454 0 0 0 1.787 10.218A9.637 9.637 0 0 1 11.636.743Z",
                    name: '',
                    areaSize: size,
                    position: (bounds) => Vector2(10.82, -0.4),
                    color: const Color(0xffFFFFFF),
                  ),
                  PathGameObject.fromSvgPath(
                    "M19.203 8.981a2.978 2.978 0 0 0-4.73-.134 4.819 4.819 0 0 1-7.385.124A4.123 4.123 0 0 0 .207 9.993a7.293 7.293 0 0 1 8.965-4.827c.02-.05.044-.099.07-.147A7.454 7.454 0 0 0 .075 9.877a9.636 9.636 0 0 1 19.127-.896Z",
                    name: '',
                    areaSize: size,
                    position: (bounds) => Vector2(18, 9),
                    color: const Color(0xffFFFFFF),
                  ),
                  PathGameObject.fromSvgPath(
                    "M.39 12.78a2.978 2.978 0 0 0 3.906-2.672 4.818 4.818 0 0 1 5.901-4.441A4.123 4.123 0 0 0 15.163.795a7.294 7.294 0 0 1-4.415 9.174 1.7 1.7 0 0 1 .03.16 7.454 7.454 0 0 0 4.56-9.317A9.636 9.636 0 0 1 .39 12.78Z",
                    name: '',
                    areaSize: size,
                    position: (bounds) => Vector2(2.69, 19),
                    color: const Color(0xffFFFFFF),
                  ),
                  PathGameObject(
                    path: starPath,
                    name: '',
                    position: Vector2(15, 5.5),
                  ),
                  PathGameObject(
                    path: starPath,
                    name: '',
                    position: Vector2(26.5, 13),
                  ),
                  PathGameObject(
                    path: starPath,
                    name: '',
                    position: Vector2(23.5, 26.5),
                  ),
                  PathGameObject(
                    path: starPath,
                    name: '',
                    position: Vector2(9.73, 27.5),
                  ),
                  PathGameObject(
                    path: starPath,
                    name: '',
                    position: Vector2(4.36, 14.64),
                  ),
                ],
              ),
            ];
          },
        );
}
