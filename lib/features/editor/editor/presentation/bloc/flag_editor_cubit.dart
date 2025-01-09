import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/features/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/features/editor/my_flags/domain/services/editor_gallery.service.dart';
import 'package:flags/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'board/board_actions.dart';

part 'flag_editor_state.dart';

abstract interface class IFlagEditorCubit
    extends DynamicStatedBlocStream<FlagEditorState>
    implements IFlagEditorBoardActions {
  EditorFlagData get initialFlag;

  ValueListenable<EditorDraggableWidget?> get selectedObject;

  Future<void> onClose();

  Future<EditorFlagData?> saveFlag();

  Future<void> exportImage();
}

class FlagEditorCubit extends StatedCubit<FlagEditorState>
    with FlagEditorBoardActions
    implements IFlagEditorCubit {
  final BuildContext context;

  static GlobalKey flagAreaKey = GlobalKey();
  @override
  final EditorFlagData initialFlag;

  @override
  ValueNotifier<EditorDraggableWidget?> selectedObject = ValueNotifier(null);

  FlagEditorCubit({
    required this.initialFlag,
    required this.context,
  }) : super();

  late final IEditorGalleryService editorGalleryService;

  @override
  Future<void> onInit() async {
    editorGalleryService = EditorGalleryServiceImpl(
      sharedPreferences,
    );

    for (final e in initialFlag.objects.whereType<ImageGameObject>()) {
      await e.init();
    }

    emit(
      SuccessState(
        FlagEditorState(
          selectedStyle: initialFlag.backgroundStyle,
          sceneObjects: const [],
        ),
      ),
    );
    super.onInit();
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
  Future<EditorFlagData?> saveFlag() async {
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

      await editorGalleryService.saveFlag(finalFlag);
      return finalFlag;
    } catch (e) {
    } finally {
      return null;
    }
  }
}
