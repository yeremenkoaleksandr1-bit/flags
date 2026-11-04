part of '../asia.dart';

class SouthKoreaFlag extends GameFlag {
  SouthKoreaFlag()
      : super(
          name: "South Korea",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xffffffff),
            ),
            EmblemPart.fromType<SouthKoreaEmblem>(
              position: Vector2(32, 16),
              size: Vector2(32, 32),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M.718 13.427 9.593.114l2.219 1.48-8.875 13.312-2.22-1.48Zm3.328 2.219 8.875-13.313 2.219 1.479-8.875 13.313-2.219-1.48Zm3.328 2.218L16.25 4.552l2.22 1.479-8.876 13.313-2.219-1.48Z",
              name: '2',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(14.72, 6.11),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M6.819 10.653 2.75 4.55.532 6.031 4.6 12.132l2.219-1.48ZM5.34 13.242l4.067 6.101 2.22-1.479-4.069-6.102-2.218 1.48Zm8.135-7.027L9.407.114 7.19 1.593l4.067 6.102 2.22-1.48Zm-1.479 2.589 4.068 6.102 2.219-1.48-4.068-6.101-2.22 1.479ZM3.86 3.812l8.876 13.313 2.218-1.48L6.08 2.333 3.86 3.812Z",
              name: '3',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(63.53, 6.11),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "m14.214 12.675 4.068-6.101-2.22-1.48-4.067 6.102 2.219 1.479Zm-3.328-2.219 4.068-6.101-2.22-1.48-4.067 6.102 2.219 1.48Zm-2.959-.37 2.22 1.48-4.069 6.101-2.219-1.479 4.068-6.102Zm-.369-1.849 4.067-6.101L9.406.656 5.34 6.759l2.219 1.48ZM4.6 7.868l2.218 1.479-4.068 6.102-2.219-1.48 4.069-6.1Zm6.656 4.437 2.218 1.48-4.068 6.101-2.218-1.479 4.068-6.102Z",
              name: '4',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(63.53, 38.66),
              previousMustBePlaced: const ['1'],
            ),
            PathGameObject.fromSvgPath(
              "M10.337 8.529 6.269 2.427 4.05 3.907l4.068 6.1 2.219-1.478Zm-1.479 2.588 4.068 6.102 2.218-1.479-4.068-6.102-2.218 1.48ZM.722 6.125l8.875 13.313 2.22-1.48L2.94 4.647.722 6.126Zm6.657-4.437L16.254 15l2.219-1.48L9.597.208 7.38 1.688Z",
              name: '5',
              color: const Color(0xff000000),
              areaSize: size,
              position: (_) => Vector2(14.72, 38.66),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
