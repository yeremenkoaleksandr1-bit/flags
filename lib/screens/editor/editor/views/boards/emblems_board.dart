import 'package:state_manager/state_manager.dart';
import 'package:flags/features/layers/layer.view.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/material.dart';

class EditorEmblemsBoard extends UiLayer {
  const EditorEmblemsBoard({super.key})
      : super(
          tag: "editor_emblems",
          initialShown: false,
        );

  static IEditorEmblemsController find() => Get.find(tag: "editor_emblems");

  @override
  State<StatefulWidget> createState() => EditorEmblemsState();
}

abstract interface class IEditorEmblemsController implements IUiLayer {}

class EditorEmblemsState
    extends UiLayerState<EditorEmblemsBoard, IEditorEmblemsController>
    implements IEditorEmblemsController {
  late final IEditorPresenter presenter =
      GetScreen.of<IEditorPresenter>(context).presenter;

  @override
  Widget buildChild(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: hide,
            child: const Material(
              color: Colors.black45,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: FCard(
              child: Placeholder(),
            ),
          ),
        ),
      ],
    );
  }
}
