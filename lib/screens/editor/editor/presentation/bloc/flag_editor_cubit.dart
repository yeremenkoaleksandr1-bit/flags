import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/logger.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flutter/foundation.dart';

import 'board/board_actions.dart';

part 'flag_editor_state.dart';

abstract interface class IFlagEditorCubit
    extends StateStreamableSource<FlagEditorState>
    implements IFlagEditorBoardActions {
  EditorFlagData get initialFlag;

  ValueListenable<EditorDraggableWidget?> get selectedObject;
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
}
