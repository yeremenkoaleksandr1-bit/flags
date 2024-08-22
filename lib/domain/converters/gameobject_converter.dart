import 'dart:convert';

import 'package:flags/domain/converters/game_objects/emblem_converter.dart';
import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/logger.dart';

import 'objects/app_structs.dart';

abstract class GameObjectConverter<T extends GameObject>
    implements IJsonConverter<T, Map<String, dynamic>> {
  const GameObjectConverter();

  @override
  Map<String, dynamic> toJson(T model) {
    final baseData = <String, dynamic>{
      "_t": model.runtimeType.toString(),
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

  static IJsonConverter<dynamic, dynamic> Function()? _parseConverter(o) {
    if (o is EmblemPart) {
      logger.f(o);
      return EmblemConverter.new;
    }

    if (o is SPath) {
      return SPathSerializer.new;
    }

    return null;
  }

  static IJsonConverter<dynamic, dynamic> Function()? _parseDeserealizer(o) {
    logger.f(o);
    if (o == "EmblemPart") {
      return EmblemConverter.new;
    }

    if (o == "SPath") {
      return SPathSerializer.new;
    }

    return null;
  }

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
