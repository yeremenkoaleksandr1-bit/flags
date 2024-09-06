import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/views/appbar.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/emblems_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/shapes_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/styles_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/bottom_buttons.dart';
import 'package:flags/screens/editor/editor/presentation/views/layers/edit_selected_item/edit_selected_item_layer.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/editor_area.view.dart';
import '../widgets/flag_style_color_changer.dart';

class EditorScreenView extends StatelessWidget {
  const EditorScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: GameSafeArea(
            child: Column(
              children: [
                Padding(
                  padding: Pad(horizontal: 8),
                  child: EditorAppBarView(),
                ),
                Gap.v12,
                Expanded(
                  child: _Content(),
                ),
              ],
            ),
          ),
        ),
        const IgnorePointer(
          child: EditorEditSelectedItemLayer(),
        ),
        StylesBoard(),
        ShapesBoard(),
        EmblemsBoard(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();
    return BlocBuilder(
      bloc: bloc,
      buildWhen: (o, n) => o.runtimeType.toString() != n.runtimeType.toString(),
      builder: (BuildContext context, state) {
        return const Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: Pad(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EditorAreaView(),
                          Gap.v4,
                          Align(
                            alignment: Alignment.topLeft,
                            child: FlagStyleColorChanger(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: EditorBottomButtonsView(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
