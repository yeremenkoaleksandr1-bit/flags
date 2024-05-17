import 'package:flags/shared/services/disposable.dart';
import 'package:state_manager/state_manager.dart';
import 'package:flags/domain/converters/editor_flag_converter.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:hive/hive.dart';

abstract interface class IEditorGalleryService implements IDisposable {
  static IEditorGalleryService get I => Get.find<IEditorGalleryService>();

  ValueListenableList<EditorFlagData> get flags;

  void saveFlag(EditorFlagData flag);
}

class EditorGalleryServiceImpl implements IEditorGalleryService {
  static const String _boxKey = "d50c16215c38";
  final Box<Map<String, dynamic>> box =
      Hive.box<Map<String, dynamic>>(name: _boxKey);

  @override
  final ValueNotifierList<EditorFlagData> flags = ValueNotifierList();

  Future<IEditorGalleryService> initialize() async {
    flags.addAll(
      box.getAll(box.keys).map(
            (e) => const EditorFlagSerializer().fromJson(e!),
          ),
    );

    return Get.put<IEditorGalleryService>(this, permanent: true);
  }

  @override
  void saveFlag(EditorFlagData flag) {
    flags.insert(flags.length, flag);
    box.put(
      flag.name,
      const EditorFlagSerializer().toJson(flag),
    );
  }

  @override
  void dispose() {
    flags.dispose();
  }
}
