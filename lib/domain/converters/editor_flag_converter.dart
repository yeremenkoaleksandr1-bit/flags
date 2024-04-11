import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/editor/editor_flag.dart';

class EditorFlagSerializer
    implements IJsonConverter<EditorFlagData, Map<String, dynamic>> {
  const EditorFlagSerializer();

  @override
  EditorFlagData fromJson(Map<String, dynamic> j) => EditorFlagData(
        name: j["name"],
        proportion: j["proportion"],
      );

  @override
  Map<String, dynamic> toJson(EditorFlagData m) => {
        "name": m.name,
        "proportion": m.proportion,
      };
}
