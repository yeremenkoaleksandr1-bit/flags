import 'dart:convert';

import 'package:flags/domain/converters/game_objects/flippable_object_converter.dart';
import 'package:flags/domain/converters/objects/app_structs.dart';
import 'package:flags/domain/game_objects/drawn_object/drawn_object.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/custom_paint/custom_paint_cubit.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class DrawnObjectConverter extends FlippableObjectConverter<DrawnGameObject> {
  const DrawnObjectConverter();

  @override
  Map<String, dynamic> toJson(DrawnGameObject model) {
    final paths = [
      ...model.pathsHistory.paths.map(
        (e) => const SPathSerializer().toJson(e),
      ),
    ];
    return super.toJson(model)
      ..addAll({
        'ps': jsonEncode(paths),
      });
  }

  @override
  DrawnGameObject fromJson(Map<String, dynamic> j) {
    final pathsJson = List.from(jsonDecode(j['ps']));
    final paths = pathsJson.map(
      (e) => const SPathSerializer().fromJson(e),
    );

    return DrawnGameObject(
      key: j['k'],
      name: j['n'] ?? UniqueKey().toString(),
      position: Vector2(j['px'], j['py']),
      scale: j['sc'],
      size: Vector2(j['sx'], j['sy']),
      rotation: j['r'],
      flippedHorizontal: j['fh'],
      flippedVertical: j['fv'],
      pathsHistory: CustomPaintState(
        paths: [...paths],
      ),
    );
  }
}
