import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/components/drawing_canvas/drawing_canvas.dart';
import 'package:flutter/material.dart';

import 'base_board.dart';

class CustomPainterBoard extends EditorBaseBoard {
  const CustomPainterBoard({
    super.key,
  });

  @override
  bool getState(FlagEditorState state) {
    return state.isOpenedCustomPaintBoard;
  }

  @override
  void onBackgroundTapped(IFlagEditorCubit bloc) {
    bloc.toggleCustomPaintBoardOpen(false);
  }

  @override
  Positioned buildWidget(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0,
      child: Material(
        type: MaterialType.card,
        color: Colors.transparent,
        child: build(context),
      ),
    );
  }

  Widget build(BuildContext context) {
    return const DrawingCanvas();
  }
}
