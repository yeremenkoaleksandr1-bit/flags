part of '../europe.dart';

class CzechFlag extends GameFlag {
  CzechFlag()
      : super(
          name: "Czech",
          proportion: 2 / 3,
          objects: (size) => [
            PathGameObject(
              name: "1",
              position: Vector2.zero(),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            PathGameObject(
              name: "2",
              position: Vector2(0, size.y / 2),
              path: SPath.rect(
                rect: Vector2(size.x, size.y / 2).toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFFD7141A),
                ),
              ),
            ),
            PathGameObject(
              name: "3",
              previousMustBePlaced: const ['1', '2'],
              path: SPath(
                rect: size.toRect(),
                paint: SPaint(
                  style: PaintingStyle.fill,
                  color: const Color(0xFF11457E),
                ),
                points: [
                  SPoint.line(size.x / 2, size.y / 2),
                  SPoint.line(0, size.y),
                  SPoint.line(0, 0),
                ],
              ),
            ),
          ],
        );
}
