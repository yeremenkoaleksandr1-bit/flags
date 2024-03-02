// import 'package:flutter/material.dart';
// import 'package:memoize/memoize.dart';
// import 'package:project/app/core/core.dart';
// import 'package:project/app/domain/domain.dart';
// import 'package:project/app/screens/editor/history/history.dart';
//
// import '../base/flippable.dart';
//
// class DrawnGameObject extends FlippableGameObject {
//   final PathHistory pathsHistory;
//
//   DrawnGameObject({
//     super.key,
//     required super.name,
//     super.position,
//     super.scale,
//     super.size,
//     super.rotation.dart,
//     required this.pathsHistory,
//     super.flippedHorizontal,
//     super.flippedVertical,
//   });
//
//   Rect get bounds => pathsHistory.currentPath.bounds;
//
//   final _cachedRect = memo1((Size size) => RectX.fromSize(size));
//
//   @override
//   void draw(Canvas canvas, Size size) {
//     canvas.translate(position.dx, position.dy);
//
//     canvas.rotate(rotation.dart);
//     canvas.scale(scale);
//     canvas.scale(
//       (flippedHorizontal ? -1 : 1),
//       (flippedVertical ? -1 : 1),
//     );
//
//     canvas.translate(-position.dx, -position.dy);
//
//     canvas.translate(
//         position.dx - this.size.width / 2, position.dy - this.size.height / 2);
//
//     canvas.scale(
//       (this.size.width / pathsHistory.originalSize.width),
//       (this.size.height / pathsHistory.originalSize.height),
//     );
//
//     canvas.clipRect(_cachedRect(pathsHistory.originalSize));
//     for (final path in pathsHistory.paths) {
//       canvas.save();
//       path.draw(canvas, size);
//       canvas.restore();
//     }
//   }
//
//   @override
//   DrawnGameObject copyWith({
//     Key? key,
//     String? name,
//     String? uniqueName,
//     Offset? position,
//     double? scale,
//     Size? size,
//     double? rotation.dart,
//     PathHistory? pathsHistory,
//     bool? flippedHorizontal,
//     bool? flippedVertical,
//   }) {
//     return DrawnGameObject(
//       key: key ?? this.key,
//       name: name ?? this.name,
//       position: position ?? this.position,
//       scale: scale ?? this.scale,
//       size: size ?? this.size,
//       rotation.dart: rotation.dart ?? this.rotation.dart,
//       pathsHistory: pathsHistory ?? this.pathsHistory,
//       flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
//       flippedVertical: flippedVertical ?? this.flippedVertical,
//     );
//   }
//
//   @override
//   Future<void> init() async => this;
//
//   @override
//   List<Object> get props => [super.props, pathsHistory];
//
//   @override
//   String getName() => name;
//
//   @override
//   List<String>? get previousMustBePlaced => [];
// }
