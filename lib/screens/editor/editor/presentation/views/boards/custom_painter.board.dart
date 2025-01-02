import 'package:flags/screens/editor/editor/custom_defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/components/drawing_canvas/drawing_canvas.dart';
import 'package:flutter/material.dart';

import 'base_board.dart';

class CustomPainterBoard extends EditorBaseBoard {
  CustomPainterBoard({super.key})
      : super(
          buildWhen: (p, c) {
            return p.isOpenedCustomPaintBoard != c.isOpenedCustomPaintBoard;
          },
        );

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
