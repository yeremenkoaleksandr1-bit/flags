import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/converters/verctor_converter.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';

class GameObjectConverter<T extends GameObject>
    implements IJsonConverter<T, Map<String, dynamic>> {
  @override
  Map<String, dynamic> toJson(T model) {
    final baseData = {
      "key": model.key,
      "name": model.name,
      "uniqueName": model.uniqueName,
      "position": model.position.toJson(),
      "scale": model.scale,
      "size": model.size.toJson(),
      "rotation": model.rotation,
    };

    return baseData;
  }

  @override
  T fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
