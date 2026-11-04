import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/features/editor/my_flags/domain/services/editor_gallery.service.dart';
import 'package:flags/features/editor/my_flags/presentation/dialogs/create_flag.dialog.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class MyFlagsCubit extends StatedCubit<List<EditorFlagData>> {
  late final IEditorGalleryService editorGalleryService;
  final SharedPreferences sharedPreferences;

  MyFlagsCubit({
    required this.sharedPreferences,
  });

  @override
  Future<void> onInit() async {
    editorGalleryService = EditorGalleryServiceImpl(
      sharedPreferences,
    );

    emit(
      SuccessState(editorGalleryService.flags),
    );

    super.onInit();
  }

  Future<void> removeFlag(EditorFlagData flag) async {
    await editorGalleryService.removeFlag(flag);

    emit(
      SuccessState(editorGalleryService.flags),
    );
  }


  void updateFlag(EditorFlagData flag) {
    emit(
      SuccessState(editorGalleryService.flags),
    );
  }

  Future<void> createFlag(
    BuildContext context,
  ) async {
    final data =
        await const CreateFlagDialog().showModal<CreateFlagData>(context);

    if (data != null) {
      final flag = EditorFlagData(
        name: data.name,
        proportion: data.proportion,
      );

      await editorGalleryService.insertFlag(flag);

      emit(
        SuccessState(editorGalleryService.flags),
      );

      if (!context.mounted) return;
      await openFlagInEditor(context, flag);
    }
  }

  Future<void> openFlagInEditor(
    BuildContext context,
    EditorFlagData flag,
  ) async {
    context.navigateTo(
      EditorRoute(
        flag: flag.clone(),
      ),
    );
    // final object = await QR.toName<EditorFlagData>(
    //   Routes.editFlag,
    //   params: {'data': flag.clone()},
    //   waitForResult: true,
    // );
    //
    // if (object != null) {
    //   state.whenOrNull(
    //     success: (state) {
    //       final index = state.indexWhere((e) => e.name == object.name);
    //
    //       if (index != -1) {
    //         final objects = [...state];
    //
    //         objects[index] = object;
    //
    //         emit(
    //           SuccessState(
    //             objects,
    //           ),
    //         );
    //       }
    //     },
    //   );
    // }
  }
}
