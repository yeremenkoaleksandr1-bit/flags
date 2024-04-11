part of '../oceania.dart';

class VanuatuFlag extends GameFlag {
  VanuatuFlag()
      : super(
          name: "Vanuatu",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.fromSvgPath(
              "M.455.287h96v32h-96z",
              name: '1',
              areaSize: size,
              color: const Color(0xffD21034),
            ),
            PathGameObject.fromSvgPath(
              "M.455.287h96v32h-96z",
              name: '2',
              areaSize: size,
              color: const Color(0xff009543),
              position: (bounds) => Vector2(0, bounds.height),
            ),
            PathGameObject.fromSvgPath(
              "M96 26.953V37.62h-48l-48 26.667v-64l48 26.666h48Z",
              name: '3',
              areaSize: size,
              color: const Color(0xff000000),
              previousMustBePlaced: const ['1', '2'],
            ),
            PathGameObject.fromSvgPath(
              "M47.534 26.222h48.921v3.556H47.534L.455 55.933v-4.068L43.413 28 .455 4.135V.067l47.079 26.155Z",
              name: '4',
              areaSize: size,
              color: const Color(0xffFDCE12),
              position: (bounds) => Vector2(-0.4, 4.07),
              previousMustBePlaced: const ['3'],
            ),
            EmblemPart.fromType<VanuatuEmblem>(
              position: Vector2(8.47, 22.84),
              size: Vector2(17.71, 18.9),
              previousMustBePlaced: const ['4'],
            ),
          ],
        );
}
