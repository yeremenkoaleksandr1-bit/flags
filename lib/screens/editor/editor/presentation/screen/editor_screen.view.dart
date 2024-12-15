import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/custom_defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/dialogs/successfull_image_saved_dialog.dart';
import 'package:flags/screens/editor/editor/presentation/views/appbar.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/custom_painter.board.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/emblems_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/shapes_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/styles_board.dart';
import 'package:flags/screens/editor/editor/presentation/views/bottom_buttons.dart';
import 'package:flags/screens/editor/editor/presentation/views/layers/edit_selected_item/edit_selected_item_layer.dart';
import 'package:flags/screens/editor/editor/presentation/widgets/actions/builder.dart';
import 'package:flags/uikit/components/buttons/button.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../views/editor_area.view.dart';
import '../widgets/flag_style_color_changer.dart';

final class EditorScreenView extends StatelessWidget {
  const EditorScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IFlagEditorCubit>();
    final selectionCubit = context.read<EditorSelectedObjectCubit>();

    return EDeferredPointerHandler(
      child: Stack(
        children: [
          Positioned.fill(
            child: RawGestureDetector(
              gestures: {
                PanGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                  PanGestureRecognizer.new,
                  (i) {
                    i.onEnd = (e) => selectionCubit.selectObject(null);
                  },
                ),
              },
              behavior: HitTestBehavior.translucent,
              child: const Material(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned.fill(
            child: GameSafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: Pad(horizontal: 8),
                    child: EditorAppBarView(),
                  ),
                  Padding(
                    padding: const Pad(horizontal: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FButton(
                        color: ThemePalette.yellowButton,
                        onPressed: () async {
                          await EasyLoading.show();
                          try {
                            await cubit.exportImage();
                            const SuccessfullImageSavedDialog().showModal();
                          } catch (e) {}
      
                          await EasyLoading.dismiss();
                        },
                        child: Icon(
                          Icons.save,
                          color: ThemePalette.brown.darken(0.5),
                        ),
                      ),
                    ),
                  ),
                  Gap.v12,
                  const Expanded(
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
          CustomPainterBoard(),
        ],
      ),
    );
  }
}

final class _Content extends StatelessWidget {
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
                          Spacer(),
                          Align(
                            alignment: Alignment.topRight,
                            child: FlagStyleColorChanger(),
                          ),
                          Gap.v4,
                          EditorAreaView(),
                          Gap.v4,
                          EditorSelectedObjectActionsBuilder(),
                          Spacer(),
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
