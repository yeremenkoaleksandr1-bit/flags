import 'dart:convert';

import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/editor/editor_flag.dart';

import 'gameobject_converter.dart';

class EditorFlagSerializer implements IJsonConverter<EditorFlagData, String> {
  const EditorFlagSerializer();

  @override
  EditorFlagData fromJson(String jsonString) {
    final j = jsonDecode(jsonString);

    final object = List.of(
      jsonDecode(
        j["objects"],
      ),
    );

    return EditorFlagData(
      name: j["name"],
      proportion: j["proportion"],
      objects: object.map(GameObjectConverter.deserialize).toList(),
    );
  }

  @override
  String toJson(EditorFlagData m) {
    return jsonEncode(
      {
        "name": m.name,
        "proportion": m.proportion,
        "objects": jsonEncode(
          m.objects.map(GameObjectConverter.serialize).toList(),
        ),
      },
    );
  }
}
