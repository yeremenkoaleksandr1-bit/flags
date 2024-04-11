import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/screens/editor/editor/components/flag_style.dart';
import 'package:flags/screens/editor/editor/object_handles/editor_draggable.dart';
import 'package:flags/uikit/game_widgets/objects/game_objects_rendering.dart';
import 'package:flutter/material.dart';

class EditorAreaView extends ArGetLocatorWidget<IEditorPresenter> {
  const EditorAreaView({super.key});

  @override
  Widget build(BuildContext context, IEditorPresenter presenter) {
    return AspectRatio(
      aspectRatio: presenter.flag.proportion,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: FastValueBuilder(
              listen: presenter.state.selectedStyle,
              builder: (FlagStyle value) => FlagStyleView(
                style: value,
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () => presenter.selectObject(null),
              child: const Material(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned.fill(
            child: DeferredPointerHandler(
              child: FastValueBuilder(
                listen: presenter.state.sceneObjects,
                builder: (Iterable<EditorDraggableWidget> value) {
                  return GameObjectsRendering([...value]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
