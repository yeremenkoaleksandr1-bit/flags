import 'package:flags/domain/converters/gameobject_converter.dart';
import 'package:flags/domain/game_objects/shape/shape_object.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/cupertino.dart';

import '../objects/app_structs.dart';

final class ShapeGameObjectConverter
    extends GameObjectConverter<ShapeGameObject> {
  @override
  ShapeGameObject fromJson(Map<String, dynamic> j) {
    return ShapeGameObject(
      key: j['k'],
      name: j['n'] ?? UniqueKey().toString(),
      uniqueName: j['un'],
      position: Vector2(j['px'], j['py']),
      scale: j['sc'],
      size: Vector2(j['sx'], j['sy']),
      rotation: j['r'],
      path: const SPathSerializer().fromJson(
        j['p'],
      ),
    );
  }

  @override
  Map<String, dynamic> toJson(ShapeGameObject model) {
    return super.toJson(model)
      ..addAll({
        'p': const SPathSerializer().toJson(model.path),
      });
  }
}
