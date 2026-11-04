import 'dart:convert';

import 'package:flags/domain/converters/game_objects/drawn_object_converter.dart';
import 'package:flags/domain/converters/game_objects/emblem_converter.dart';
import 'package:flags/domain/converters/game_objects/shape_converter.dart';
import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/domain/game_objects/shape/shape_object.dart';

import 'game_objects/image_converter.dart';
import 'objects/app_structs.dart';

abstract class GameObjectConverter<T extends GameObject>
    implements IJsonConverter<T, Map<String, dynamic>> {
  const GameObjectConverter();

  @override
  Map<String, dynamic> toJson(T model) {
    final baseData = <String, dynamic>{
      "_t": model.runtimeType.toString(),
      "n": model.name,
      "un": model.uniqueName,
      "px": model.position.x,
      "py": model.position.y,
      "sc": model.scale,
      "sx": model.size.x,
      "sy": model.size.y,
      "r": model.rotation,
    };

    return baseData;
  }

  @override
  T fromJson(Map<String, dynamic> json);

  static IJsonConverter<dynamic, dynamic> Function()? _parseConverter(dynamic o) =>
      switch (o) {
        (EmblemPart _) => EmblemConverter.new,
        (SPath _) => SPathSerializer.new,
        (ShapeGameObject _) => ShapeGameObjectConverter.new,
        (DrawnGameObject _) => DrawnObjectConverter.new,
        (ImageGameObject _) => ImageGameObjectConverter.new,
        _ => null,
      };

  static IJsonConverter<dynamic, dynamic> Function()? _parseDeserealizer(String o) =>
      switch (o) {
        "EmblemPart" => EmblemConverter.new,
        "SPath" => SPathSerializer.new,
        "ShapeGameObject" => ShapeGameObjectConverter.new,
        "DrawnGameObject" => DrawnObjectConverter.new,
        "ImageGameObject" => ImageGameObjectConverter.new,
        _ => null,
      };

  static String serialize(dynamic o) {
    final data = _parseConverter(o)?.call().toJson(o) ?? {};

    return jsonEncode(data);
  }

  static GameObject deserialize(dynamic o) {
    final decoded = jsonDecode(o.toString());

    final data = _parseDeserealizer(decoded["_t"])?.call().fromJson(decoded);

    return data;
  }
}
