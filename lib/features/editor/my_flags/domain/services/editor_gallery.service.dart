import 'dart:convert';

import 'package:flags/domain/converters/editor_flag_converter.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IEditorGalleryService {
  List<EditorFlagData> get flags;

  Future<void> saveFlag(EditorFlagData flag);

  Future<void> insertFlag(EditorFlagData flag);

  Future<void> removeFlag(EditorFlagData flag);
}

class EditorGalleryServiceImpl implements IEditorGalleryService {
  static const String _prefsKey = "editor_flags";
  final SharedPreferences _prefs;

  EditorGalleryServiceImpl(this._prefs);

  @override
  List<EditorFlagData> get flags => [
        ...(_prefs.getStringList(_prefsKey) ?? []).map(
          (e) => const EditorFlagSerializer().fromJson(e),
        ),
      ];

  @override
  Future<void> saveFlag(EditorFlagData flag) async {
    final list = _prefs.getStringList(_prefsKey) ?? [];

    final jsonData = const EditorFlagSerializer().toJson(flag);

    final index = list.indexWhere(
      (element) => jsonDecode(element)["name"] == flag.name,
    );

    if (index != -1) {
      list[index] = jsonData;
    } else {
      list.insert(0, jsonData);
    }

    await _prefs.setStringList(_prefsKey, list);
  }

  @override
  Future<void> insertFlag(EditorFlagData flag) async {
    await saveFlag(flag);
  }

  @override
  Future<void> removeFlag(EditorFlagData flag) async {
    final list = _prefs.getStringList(_prefsKey) ?? [];
    final data = const EditorFlagSerializer().toJson(flag);
    list.remove(data);
    await _prefs.setStringList(_prefsKey, list);
  }
}
