import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/logger.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:meta/meta.dart';

part 'selected_object_state.dart';

final class EditorSelectedObjectCubit extends Cubit<EditorSelectedObjectState> {
  EditorSelectedObjectCubit()
      : super(
          const EditorSelectedObjectState(
            object: null,
          ),
        );

  void selectObject(EditorDraggableWidget? object) {
    emit(
      state.copyWith(
        object: object,
      ),
    );
  }
}
