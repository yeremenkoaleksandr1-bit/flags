import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/screens/editor/editor/components/flag_style.dart';
import 'package:flags/screens/editor/editor/object_handles/editor_draggable.dart';
import 'package:flags/uikit/game_widgets/objects/game_objects_rendering.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class EditorAreaView extends GetConsumer<IEditorPresenter> {
  const EditorAreaView({super.key});

  @override
  Widget build(BuildContext context, IEditorPresenter controller) {
    return AspectRatio(
      aspectRatio: controller.flag.proportion,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: controller.state.selectedStyle,
              builder: (BuildContext context, value, Widget? child) {
                return FlagStyleView(
                  style: value,
                );
              },
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () => controller.selectObject(null),
              child: const Material(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned.fill(
            child: DeferredPointerHandler(
              child: ValueListenableBuilder(
                valueListenable: controller.state.sceneObjects,
                builder: (
                  BuildContext context,
                  List<EditorDraggableWidget> value,
                  Widget? child,
                ) {
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
