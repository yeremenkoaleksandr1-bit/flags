import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:meta/meta.dart';

part 'flag_editor_event.dart';

part 'flag_editor_state.dart';

class FlagEditorBloc extends Bloc<FlagEditorEvent, FlagEditorState> {
  final EditorFlagData initialFlag;

  FlagEditorBloc(this.initialFlag) : super(FlagEditorLoadingState()) {
    on<FlagEditorEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FlagEditorInitializeEvent>(_onInitialize);
  }

  FutureOr<void> _onInitialize(
    FlagEditorInitializeEvent event,
    Emitter<FlagEditorState> emit,
  ) {
    emit(FlagEditorReadyState());
  }
}
