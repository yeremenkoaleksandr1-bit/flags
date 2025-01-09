part of '../asia.dart';

class HongKongFlag extends GameFlag {
  HongKongFlag()
      : super(
          name: "Hong Kong",
          proportion: 2 / 3,
          objects: (size) {
            final starsPath = parseSvgPathModel(
              "m12.142 1.195 1.123-.49-.62 1.057.813.916-1.197-.263-.62 1.056-.12-1.22-1.196-.263 1.123-.49-.119-1.22.813.917Zm11.73 6.995 1.123-.49-.62 1.056.813.917-1.197-.264-.62 1.056-.12-1.22-1.196-.263 1.123-.49-.119-1.22.813.917ZM20.85 21.501l1.124-.49-.62 1.057.812.917-1.196-.264-.621 1.056-.119-1.22-1.196-.263 1.123-.49-.119-1.22.813.917Zm-13.6 1.238 1.123-.49-.62 1.057.813.916-1.197-.264-.62 1.057-.12-1.22-1.196-.264 1.123-.49-.119-1.219.813.917ZM1.875 10.183l1.123-.49-.62 1.057.812.917-1.196-.264-.621 1.056-.119-1.22-1.196-.263 1.123-.49-.12-1.22.814.917Z",
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
                  PathGameObject(
                    path: parseSvgPathModel(
                      "M11.113.114a2.978 2.978 0 0 0-1.59 4.458 4.82 4.82 0 0 1-2.164 7.061 4.122 4.122 0 0 0-1.154 6.86 7.293 7.293 0 0 1-1.82-10.017 1.688 1.688 0 0 1-.119-.112 7.454 7.454 0 0 0 1.788 10.218A9.636 9.636 0 0 1 11.113.114Z",
                      paint: SPaint(
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                    name: '',
                    position: Vector2(10.82, 0),
                    size: Vector2(11.11, 18.58),
                  ),
                  PathGameObject(
                    path: parseSvgPathModel(
                      "M19.503 8.352a2.978 2.978 0 0 0-4.73-.134 4.818 4.818 0 0 1-7.385.124A4.123 4.123 0 0 0 .507 9.365 7.293 7.293 0 0 1 9.47 4.537c.021-.05.044-.099.07-.147A7.454 7.454 0 0 0 .375 9.248a9.636 9.636 0 0 1 19.128-.896Z",
                      paint: SPaint(
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                    name: '',
                    position: Vector2(17.38, 9.25),
                    size: Vector2(19.13, 9.75),
                  ),
                  PathGameObject(
                    path: parseSvgPathModel(
                      "M7.608 18.535a2.979 2.979 0 0 0-1.334-4.54 4.818 4.818 0 0 1-2.4-6.986A4.123 4.123 0 0 0 .775.781a7.293 7.293 0 0 1 7.361 7.034c.054.004.108.011.162.021A7.454 7.454 0 0 0 .846.62a9.637 9.637 0 0 1 6.762 17.915Z",
                      paint: SPaint(
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                    name: '',
                    position: Vector2(17.78, 18.33),
                    size: Vector2(12.07, 18.21),
                  ),
                  PathGameObject(
                    path: parseSvgPathModel(
                      "M.69 12.15a2.979 2.979 0 0 0 3.905-2.67 4.818 4.818 0 0 1 5.901-4.441A4.123 4.123 0 0 0 15.463.166a7.294 7.294 0 0 1-4.415 9.174c.012.053.022.107.03.16a7.454 7.454 0 0 0 4.56-9.317A9.636 9.636 0 0 1 .689 12.151Z",
                      paint: SPaint(
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                    name: '',
                    position: Vector2(2.69, 19.17),
                    size: Vector2(16.43, 14.79),
                  ),
                  PathGameObject(
                    path: parseSvgPathModel(
                      "M1.036.64a2.978 2.978 0 0 0 3.748 2.89 4.818 4.818 0 0 1 6.048 4.24A4.124 4.124 0 0 0 17 10.988 7.294 7.294 0 0 1 6.91 9.623a1.686 1.686 0 0 1-.143.078 7.454 7.454 0 0 0 10.27 1.458A9.637 9.637 0 0 1 1.036.641Z",
                      paint: SPaint(
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                    name: '',
                    position: Vector2(0, 8.64),
                    size: Vector2(17.04, 13.98),
                  ),
                  PathGameObject(
                    path: starsPath,
                    name: '',
                    position: Vector2(4.36, 5.65),
                  ),
                ],
              ),
            ];
          },
        );
}
