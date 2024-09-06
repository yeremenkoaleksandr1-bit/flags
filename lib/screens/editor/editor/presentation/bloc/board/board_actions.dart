import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class IFlagEditorBoardActions {
  void toggleStylesBoardOpen(bool value);

  void toggleShapesBoardOpen(bool value);

  void toggleEmblemsBoardOpen(bool value);

  void toggleCustomPaintBoardOpen(bool value);
}

mixin FlagEditorBoardActions on Cubit<FlagEditorState>
    implements IFlagEditorBoardActions {
  @override
  void toggleStylesBoardOpen(bool value) {
    emit(
      state.copyWith(
        isOpenedStylesBoard: value,
      ),
    );
  }

  @override
  void toggleShapesBoardOpen(bool value) {
    emit(
      state.copyWith(
        isOpenedShapesBoard: value,
      ),
    );
  }

  @override
  void toggleEmblemsBoardOpen(bool value) {
    emit(
      state.copyWith(
        isOpenedEmblemsBoard: value,
      ),
    );
  }

  @override
  void toggleCustomPaintBoardOpen(bool value) {
    emit(
      state.copyWith(
        isOpenedCustomPaintBoard: value,
      ),
    );
  }
}
