import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/styles/style.dart';

part 'flag_background_style_state.dart';

class EditorFlagBackgroundStyleCubit
    extends Cubit<EditorFlagBackgroundStyleState> {
  EditorFlagBackgroundStyleCubit({
    required FlagStyle initialStyle,
  }) : super(
          EditorFlagBackgroundStyleState(
            style: initialStyle,
          ),
        );

  void changeStyle(FlagStyle value) {
    final newColors = [...value.colors];
    for (var i = 0;
        i < value.colors.length && i < state.style.colors.length;
        i++) {
      newColors[i] = state.style.colors[i];
    }
    final newValue = value.copyWith(colors: newColors);

    emit(
      EditorFlagBackgroundStyleState(
        style: newValue,
      ),
    );
  }

  void changeColor(int index, Color value) {
    emit(
      EditorFlagBackgroundStyleState(
        style: state.style.changeColor(index, value),
      ),
    );
  }
}
