part of '../africa.dart';

class TanzaniaFlag extends GameFlag {
  TanzaniaFlag()
      : super(
          name: "Tanzania",
          proportion: 2 / 3,
          objects: (size) {
            return [
              PathGameObject.fromSvgPath(
                "M0 0v48.777L73.165 0H0Z",
                name: '1',
                color: const Color(0xff1EB53A),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathGameObject.fromSvgPath(
                "M73.165 0H96v15.223L22.835 64H0V48.777L73.165 0Z",
                name: '2',
                color: const Color(0xffFCD116),
                areaSize: size,
                position: (_) => Vector2(0, 0),
              ),
              PathGameObject.fromSvgPath(
                "M80.376 0H96v10.416L15.624 64H0V53.584L80.376 0Z",
                name: '4',
                color: const Color(0xff000000),
                areaSize: size,
                previousMustBePlaced: const ['2'],
                position: (_) => Vector2(0, 0),
              ),
              PathGameObject.fromSvgPath(
                "M74 49V.223L.835 49H74Z",
                name: '3',
                color: const Color(0xff00A3DD),
                areaSize: size,
                position: (_) => Vector2(22, 15),
              ),
            ];
          },
        );
}
