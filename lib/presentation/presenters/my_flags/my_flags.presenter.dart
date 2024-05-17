import 'package:flags/shared/services/disposable.dart';
import 'package:state_manager/state_manager.dart';
import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/services/editor/editr_gallery.service.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/screens/editor/my_flags/dialogs/create_flag.dialog.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract interface class IMyFlagsPresenter
    with StateMixin<List<EditorFlagData>>
    implements IDisposable {
  Future<void> createFlag();

  Future<void> openFlag(EditorFlagData flag);

  ValueListenableList<EditorFlagData> get flags;
}

class MyFlagsPresenterImpl extends GetxController
    with StateMixin<List<EditorFlagData>>
    implements IMyFlagsPresenter {
  late final IEditorGalleryService editorGalleryService;

  @override
  ValueListenableList<EditorFlagData> get flags => editorGalleryService.flags;

  @override
  Future<void> onInit() async {
    editorGalleryService = await EditorGalleryServiceImpl().initialize();
    change(
      const SuccessStatus([]),
    );

    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<IEditorGalleryService>();
    super.onClose();
  }

  @override
  Future<void> createFlag() async {
    final data = await const CreateFlagDialog().showModal<CreateFlagData>();

    if (data != null) {
      final flag = EditorFlagData(
        name: data.name,
        proportion: data.proportion,
      );

      editorGalleryService.saveFlag(flag);

      await openFlag(flag);
    }
  }

  @override
  Future<void> openFlag(EditorFlagData flag) async {
    await QR.toName(
      Routes.editor,
      params: {'data': flag},
    );
  }
}
