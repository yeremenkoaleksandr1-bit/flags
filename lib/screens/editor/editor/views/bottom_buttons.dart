import 'package:armar/armar.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flutter/cupertino.dart';

class EditorBottomButtonsView extends ArGetLocatorWidget<IEditorPresenter> {
  const EditorBottomButtonsView({super.key});

  @override
  Widget build(BuildContext context, IEditorPresenter presenter) {
    return Row(
      children: [
        Expanded(
          child: FGreenButton(
            onPressed: presenter.openStylesBoard,
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("styles")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: presenter.openShapesBoard,
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("shapes")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: presenter.openEmblemsBoard,
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("emblems")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: presenter.openCustomPainterBoard,
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("custom")),
            ),
          ),
        ),
      ],
    );
  }
}
