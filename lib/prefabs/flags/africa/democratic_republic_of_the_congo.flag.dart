part of '../africa.dart';

class DemocraticRepublicOfTheCongoFlag extends GameFlag {
  DemocraticRepublicOfTheCongoFlag()
      : super(
          name: "Democratic republic of the congo",
          proportion: 3 / 4,
          objects: (size) => [
            PathPart.fromSvgPath(
              "M0 48 80 0H0v48Z",
              name: '1',
              color: const Color(0xff007FFF),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M.84 9.8H9.8L12.573.84l2.774 8.96h8.96l-7.254 5.547 2.774 8.96-7.254-5.547-7.253 5.547 2.773-8.96L.84 9.8Z",
              name: '5',
              color: const Color(0xffF7D618),
              areaSize: size,
              position: (_) => Vector2(3, 3),
              previousMustBePlaced: const ['1'],
            ),
            PathPart.fromSvgPath(
              "M80 0 0 48v16h5.333l80-48V0H80Z",
              name: '2',
              color: const Color(0xffF7D618),
              areaSize: size,
              position: (_) => Vector2(0, 0),
            ),
            PathPart.fromSvgPath(
              "M.333 48h80V0l-80 48Z",
              name: '3',
              color: const Color(0xff007FFF),
              areaSize: size,
              position: (_) => Vector2(5.33, 15.81),
            ),
            PathPart.fromSvgPath(
              "M85.333-.186 0 51.014v12.8l85.333-51.2v-12.8Z",
              name: '4',
              color: const Color(0xffCE1021),
              areaSize: size,
              previousMustBePlaced: const ['2'],
              position: (_) => Vector2(0, 0),
            ),
          ],
        );
}
