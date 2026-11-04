import 'dart:convert';

import 'package:flags/domain/converters/background_styles/flag_style_serializer.dart';
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

    final gObject = EditorFlagData(
      name: j["name"],
      proportion: j["proportion"],
      objects: object.map(GameObjectConverter.deserialize).toList(),
    );

    return gObject.copyWith(
      backgroundStyle: FlagStyleSerializer.createFromName(
        j['bst'],
      )!
          .call()
          .fromJson(j['bs']),
    );
  }

  @override
  String toJson(EditorFlagData m) {
    return jsonEncode(
      {
        "name": m.name,
        "proportion": m.proportion,
        'bst': m.backgroundStyle.runtimeType.toString(),
        "bs": FlagStyleSerializer.createFromName(
          m.backgroundStyle.runtimeType.toString(),
        )!
            .call()
            .toJson(
              m.backgroundStyle,
            ),
        "objects": jsonEncode(
          m.objects.map(GameObjectConverter.serialize).toList(),
        ),
      },
    );
  }
}
