import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/services/editor/editr_gallery.service.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/screens/editor/my_flags/dialogs/create_flag.dialog.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract interface class IMyFlagsPresenter
    with StateMixin<List<EditorFlagData>> {
  Future<void> createFlag();

  Future<void> openFlag(EditorFlagData flag);

  RxList<EditorFlagData> get flags;
}

class MyFlagsPresenterImpl extends GetxController
    with StateMixin<List<EditorFlagData>>
    implements IMyFlagsPresenter {
  late final IEditorGalleryService editorGalleryService;

  @override
  RxList<EditorFlagData> get flags => editorGalleryService.flags;

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
    logger.i(data);

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
