import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_bloc.dart';
import 'package:flags/screens/editor/editor/presentation/views/appbar.dart';
import 'package:flags/screens/editor/editor/presentation/views/bottom_buttons.dart';
import 'package:flags/screens/editor/editor/presentation/views/layers/edit_selected_item/edit_selected_item_layer.dart';
import 'package:flags/shared/animations/slide_transition.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/editor_area.view.dart';

class EditorScreenView extends StatelessWidget {
  const EditorScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
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
        IgnorePointer(
          child: EditorEditSelectedItemLayer(),
        ),
        // EditorShapesBoard(),
        // EditorStylesBoard(),
        // EditorEmblemsBoard(),
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
    final bloc = context.read<FlagEditorBloc>();
    return BlocBuilder(
      bloc: bloc,
      buildWhen: (o, n) => o.runtimeType.toString() != n.runtimeType.toString(),
      builder: (BuildContext context, state) {
        Widget child = const SizedBox();

        if (state is FlagEditorReadyState) {
          child = const Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: Pad(horizontal: 4),
                        child: EditorAreaView(),
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
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: slideTransitionBuilder,
          child: child,
        );
      },
    );
  }
}
