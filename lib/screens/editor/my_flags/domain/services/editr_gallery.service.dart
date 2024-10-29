import 'package:flags/domain/converters/editor_flag_converter.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:hive/hive.dart';
import 'package:state_manager/state_manager.dart';

abstract interface class IEditorGalleryService implements IDisposable {
  static IEditorGalleryService get I => Get.find<IEditorGalleryService>();

  List<EditorFlagData> get flags;

  Future<void> saveFlag(EditorFlagData flag);

  Future<void> insertFlag(EditorFlagData flag);

  Future<void> removeFlag(EditorFlagData flag);
}

class EditorGalleryServiceImpl implements IEditorGalleryService {
  static const String _boxKey = "d50c16215c38";
  final Box<String> box = Hive.box<String>(name: _boxKey);

  @override
  List<EditorFlagData> get flags => [
        ...box.getAll(box.keys).map(
              (e) => const EditorFlagSerializer().fromJson(e!),
            ),
      ];

  Future<IEditorGalleryService> initialize() async {
    //box.clear();

    return Get.put<IEditorGalleryService>(this, permanent: true);
  }

  @override
  Future<void> saveFlag(EditorFlagData flag) async {
    final data = const EditorFlagSerializer().toJson(flag);

    box.put(flag.name, data);
  }

  @override
  void dispose() {}

  @override
  Future<void> insertFlag(EditorFlagData flag) async {
    flags.insert(flags.length, flag);
    await saveFlag(flag);
  }

  @override
  Future<void> removeFlag(EditorFlagData flag) async {
    flags.remove(flag);
    box.delete(flag.name);
  }
}
