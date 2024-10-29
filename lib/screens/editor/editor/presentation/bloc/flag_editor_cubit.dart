import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/screens/editor/my_flags/domain/services/editr_gallery.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'board/board_actions.dart';

part 'flag_editor_state.dart';

abstract interface class IFlagEditorCubit
    extends StateStreamableSource<FlagEditorState>
    implements IFlagEditorBoardActions {
  EditorFlagData get initialFlag;

  ValueListenable<EditorDraggableWidget?> get selectedObject;

  Future<void> onClose(BuildContext context);

  Future<void> exportImage();
}

class FlagEditorCubit extends Cubit<FlagEditorState>
    with FlagEditorBoardActions
    implements IFlagEditorCubit {
  static GlobalKey flagAreaKey = GlobalKey();
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
        ) {
    for (final e in initialFlag.objects.whereType<ImageGameObject>()) {
      e.init();
    }
  }

  @override
  Future<void> exportImage() async {
    final RenderRepaintBoundary boundary = flagAreaKey.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 6.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(
      pngBytes,
      name: initialFlag.name,
      quality: 100,
    );
  }

  @override
  Future<void> onClose(BuildContext context) async {
    await EasyLoading.show();
    try {
      final sceneObjectsCubit = context.read<EditorSceneObjectsCubit>();
      final backgroundStyleCubit =
          context.read<EditorFlagBackgroundStyleCubit>();

      final objects = sceneObjectsCubit.state.objects.map((e) => e.gameObject);
      final backgroundStyle = backgroundStyleCubit.state.style;

      final finalFlag = initialFlag.copyWith(
        objects: [...objects],
        backgroundStyle: backgroundStyle,
      );

      IEditorGalleryService.I.saveFlag(finalFlag);
      await QR.back(finalFlag);
    } catch (e) {}

    await EasyLoading.dismiss();
  }
}
