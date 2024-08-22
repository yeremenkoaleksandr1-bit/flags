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
}
