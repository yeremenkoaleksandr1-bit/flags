import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';


abstract interface class IFlagEditorBoardActions {
  void toggleStylesBoardOpen(bool value);

  void toggleShapesBoardOpen(bool value);

  void toggleEmblemsBoardOpen(bool value);

  void toggleCustomPaintBoardOpen(bool value);
}

mixin FlagEditorBoardActions on StatedCubit<FlagEditorState>
    implements IFlagEditorBoardActions {
  @override
  void toggleStylesBoardOpen(bool value) {
    state.whenOrNull(
      success: (state) {
        emit(
          SuccessState(
            state.copyWith(
              isOpenedStylesBoard: value,
            ),
          ),
        );
      },
    );
  }

  @override
  void toggleShapesBoardOpen(bool value) {
    state.whenOrNull(
      success: (state) {
        emit(
          SuccessState(
            state.copyWith(
              isOpenedShapesBoard: value,
            ),
          ),
        );
      },
    );
  }

  @override
  void toggleEmblemsBoardOpen(bool value) {
    state.whenOrNull(
      success: (state) {
        emit(
          SuccessState(
            state.copyWith(
              isOpenedEmblemsBoard: value,
            ),
          ),
        );
      },
    );
  }

  @override
  void toggleCustomPaintBoardOpen(bool value) {
    state.whenOrNull(
      success: (state) {
        emit(
          SuccessState(
            state.copyWith(
              isOpenedCustomPaintBoard: value,
            ),
          ),
        );
      },
    );
  }
}
