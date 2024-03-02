// import 'dart:ui';
//
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'path_point_model.freezed.dart';
//
// part 'path_point_model.g.dart';
//
// @freezed
// class PathPoint with _$PathPoint {
//   const factory PathPoint.move(double x, double y) = PathMovePoint;
//
//   const factory PathPoint.line(double x, double y) = PathLinePoint;
//
//   const factory PathPoint.cubit(
//           double x1, double y1, double x2, double y2, double x3, double y3) =
//       PathCubitPoint;
//
//   factory PathPoint.fromJson(Map<String, dynamic> json) =>
//       _$PathPointFromJson(json);
// }
//
// extension PathPointX on PathPoint {
//   void drawPoint(Path path) {
//     if (this is PathMovePoint) {
//       (this as PathMovePoint).draw(path);
//     } else if (this is PathLinePoint) {
//       (this as PathLinePoint).draw(path);
//     } else if (this is PathCubitPoint) {
//       (this as PathCubitPoint).draw(path);
//     }
//   }
// }
//
// extension PathMovePointX on PathMovePoint {
//   void draw(Path path) {
//     path.moveTo(x, y);
//   }
// }
//
// extension PathLinePointX on PathLinePoint {
//   void draw(Path path) {
//     path.lineTo(x, y);
//   }
// }
//
// extension PathCubitPointX on PathCubitPoint {
//   void draw(Path path) {
//     path.cubicTo(x1, y1, x2, y2, x3, y3);
//   }
// }
