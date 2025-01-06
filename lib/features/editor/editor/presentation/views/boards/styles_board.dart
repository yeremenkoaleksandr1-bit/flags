import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/components/flag_style.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/styles/styles_board_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/features/editor/editor/presentation/views/boards/base_board.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StylesBoard extends EditorBaseBoard {
  const StylesBoard({super.key});

  @override
  bool getState(FlagEditorState state) {
    return state.isOpenedStylesBoard;
  }

  @override
  Positioned buildWidget(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: constraints.biggest.height / 2,
      child: Material(
        type: MaterialType.card,
        color: Colors.transparent,
        child: build(context),
      ),
    );
  }

  @override
  void onBackgroundTapped(IFlagEditorCubit bloc) {
    bloc.toggleStylesBoardOpen(false);
  }

  Widget build(BuildContext context) {
    final editorBloc = context.read<IFlagEditorCubit>();
    final backgroundStyleCubit = context.read<EditorFlagBackgroundStyleCubit>();

    return FCard(
      child: BlocBuilder<StylesBoardCubit, StylesBoardState>(
        builder: (context, state) {
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              ...state.items.entries.map(
                    (e) =>
                    ScaledGestureDetector(
                      onTap: () => backgroundStyleCubit.changeStyle(e.value),
                      child: FCard(
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: editorBloc.initialFlag
                                      .proportion,
                                  child: FlagStyleView(
                                    style: e.value,
                                  ),
                                ),
                              ),
                            ),
                            Text(e.key),
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
