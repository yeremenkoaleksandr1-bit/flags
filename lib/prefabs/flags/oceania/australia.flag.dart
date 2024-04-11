part of '../oceania.dart';

class AustraliaFlag extends GameFlag {
  AustraliaFlag()
      : super(
          name: "Australia",
          proportion: 1 / 2,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff012169),
            ),
            PathGameObject.fromSvgPath(
              "m21.15 42.988.882 2.741 2.692-1.02-1.593 2.399 2.476 1.469-2.868.25.395 2.851-1.984-2.086-1.983 2.086.395-2.851-2.869-.25 2.476-1.47-1.593-2.398 2.693 1.02.881-2.74Zm-16-25.333.882 2.74 2.692-1.019-1.593 2.398 2.476 1.47-2.868.25.395 2.851-1.984-2.087-1.983 2.087.395-2.852-2.869-.25 2.476-1.469-1.593-2.398 2.693 1.02.881-2.741Zm16-17.333.882 2.74 2.692-1.02-1.593 2.399 2.476 1.47-2.868.249.395 2.852-1.984-2.087-1.983 2.087.395-2.852-2.869-.25 2.476-1.47-1.593-2.397 2.693 1.02.881-2.741Zm14.222 13.066.882 2.741 2.692-1.02-1.593 2.399 2.476 1.469-2.868.25.395 2.851-1.984-2.087-1.983 2.087.395-2.852-2.868-.25 2.476-1.468-1.594-2.399 2.693 1.02.881-2.74ZM27.55 26.226l.697 1.708 1.84.135-1.41 1.19.44 1.791-1.567-.972-1.567.972.44-1.79-1.409-1.191 1.84-.135.696-1.708Z",
              name: '2',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(75.54, 6.1),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "m9.478.4 1.851 5.756 5.654-2.141-3.345 5.036 5.2 3.085-6.024.524.83 5.99-4.166-4.383-4.165 4.382.83-5.989-6.024-.524 5.2-3.085-3.347-5.036 5.655 2.14L9.478.4Z",
              name: '3',
              color: const Color(0xFFFFFFFF),
              areaSize: size,
              position: (_) => Vector2(22.64, 38.4),
              previousMustBePlaced: const ['1'],
            ),
            GroupedPathsPart(
              name: 'flag_uk',
              position: Vector2.zero(),
              size: Vector2(64, 32),
              previousMustBePlaced: const ['1'],
              objects: (visualSize) => [
                PathGameObject.rect(
                  name: "1",
                  size: visualSize,
                  color: const Color(0xff012169),
                  position: Vector2.zero(),
                ),
                PathGameObject.fromSvgPath(
                  "M0 3.578 24.845 16 0 28.422V32h7.155L32 19.578 56.844 32H64v-3.578L39.155 16 64 3.578V0h-7.156L32 12.422 7.155 0H0v3.578Z",
                  name: '2',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 2.385 27.23 16H32L0 32h4.77L32 18.385V16l32 16v-2.385L36.77 16H32L64 0h-4.77L32 13.615V16L0 0v2.385Z",
                  name: '3',
                  color: const Color(0xFFE4002B),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 10.707v10.706h26.667V32.01h10.666V21.413H64V10.707H37.333V0H26.667v10.707H0Z",
                  name: '4',
                  color: const Color(0xFFFFFFFF),
                  areaSize: size,
                ),
                PathGameObject.fromSvgPath(
                  "M0 12.8v6.4h28.8V32h6.4V19.2H64v-6.4H35.2V0h-6.4v12.8H0Z",
                  name: '5',
                  color: const Color(0xFFE4002B),
                  areaSize: size,
                ),
              ],
            ),
          ],
        );
}
