import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/logger.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/screens/editor/my_flags/presentation/dialogs/create_flag.dialog.dart';
import 'package:flags/shared/bloc/state/status_bloc_state.dart';
import 'package:flags/shared/bloc/stated_cubit.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../domain/services/editr_gallery.service.dart';

final class MyFlagsCubit extends StatedCubit<List<EditorFlagData>> {
  late final IEditorGalleryService editorGalleryService;

  MyFlagsCubit();

  @override
  Future<void> onInit() async {
    editorGalleryService = await EditorGalleryServiceImpl().initialize();

    change(
      SuccessState(editorGalleryService.flags),
    );

    super.onInit();
  }

  Future<void> removeFlag(EditorFlagData flag) async {
    await editorGalleryService.removeFlag(flag);

    change(
      SuccessState(editorGalleryService.flags),
    );
  }

  Future<void> createFlag() async {
    final data = await const CreateFlagDialog().showModal<CreateFlagData>();

    if (data != null) {
      final flag = EditorFlagData(
        name: data.name,
        proportion: data.proportion,
      );

      await editorGalleryService.insertFlag(flag);

      change(
        SuccessState(editorGalleryService.flags),
      );

      await openFlagInEditor(flag);
    }
  }

  Future<void> openFlagInEditor(EditorFlagData flag) async {
    final object = await QR.toName<EditorFlagData>(
      Routes.editFlag,
      params: {'data': flag.clone()},
      waitForResult: true,
    );

    if (object != null) {
      state.when(
        success: (state) {
          final index = state.data.indexWhere((e) => e.name == object.name);

          if (index != -1) {
            final objects = [...state.data];

            objects[index] = object;

            emit(
              state.copyWith(
                data: objects,
              ),
            );
          }
        },
      );
    }
  }
}
