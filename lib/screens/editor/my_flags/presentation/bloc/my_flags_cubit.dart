import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/shared/bloc/state/status_bloc_state.dart';
import 'package:flags/shared/bloc/stated_cubit.dart';
import 'package:meta/meta.dart';
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
}
