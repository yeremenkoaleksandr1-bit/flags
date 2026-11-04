import 'dart:convert';

import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/editor/styles/style.dart';

import 'background_styles/flag_style_serializer.dart';

class EditorFlagSerializer implements IJsonConverter<FlagStyle, String> {
  const EditorFlagSerializer();

  @override
  FlagStyle fromJson(String jsonString) {
    final j = jsonDecode(jsonString);

    return FlagStyleSerializer.createFromName(j['t'])!
        .call()
        .fromJson(jsonString);
  }

  @override
  String toJson(FlagStyle m) {
    return FlagStyleSerializer.createFromName(m.runtimeType.toString())!
        .call()
        .toJson(m);
  }
}
