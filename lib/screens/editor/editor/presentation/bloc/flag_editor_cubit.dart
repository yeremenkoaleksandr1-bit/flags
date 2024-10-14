import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flags/core/extensions/image.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/screens/editor/my_flags/domain/services/editr_gallery.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'board/board_actions.dart';

part 'flag_editor_state.dart';

abstract interface class IFlagEditorCubit
    extends StateStreamableSource<FlagEditorState>
    implements IFlagEditorBoardActions {
  EditorFlagData get initialFlag;

  ValueListenable<EditorDraggableWidget?> get selectedObject;

  Future<void> onClose(BuildContext context);
}

class FlagEditorCubit extends Cubit<FlagEditorState>
    with FlagEditorBoardActions
    implements IFlagEditorCubit {
  @override
  final EditorFlagData initialFlag;

  @override
  ValueNotifier<EditorDraggableWidget?> selectedObject = ValueNotifier(null);

  FlagEditorCubit(this.initialFlag)
      : super(
          FlagEditorState(
            selectedStyle: initialFlag.backgroundStyle,
            sceneObjects: const [],
          ),
        );

  @override
  Future<void> onClose(BuildContext context) async {
    //await EasyLoading.show();
    final sceneObjectsCubit = context.read<EditorSceneObjectsCubit>();
    final backgroundStyleCubit = context.read<EditorFlagBackgroundStyleCubit>();

    final objects = sceneObjectsCubit.state.objects.map((e) => e.gameObject);
    final backgroundStyle = backgroundStyleCubit.state.style;

    final finalFlag = initialFlag.copyWith(
      objects: [...objects],
      backgroundStyle: backgroundStyle,
    );

    IEditorGalleryService.I.saveFlag(finalFlag);
    await QR.back(finalFlag);

    print(objects.length);

    // await EasyLoading.dismiss();
  }
}
