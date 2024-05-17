import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

import 'handle_button.dart';

class EditorDraggableWidget extends DraggableGameObjectWidget<GameObject> {
  const EditorDraggableWidget(
    super.gameObject, {
    super.key,
  });

  @override
  State<EditorDraggableWidget> createState() => EditorDraggableWidgetState();
}

class EditorDraggableWidgetState
    extends DraggableGameObjectWidgetState<GameObject, EditorDraggableWidget> {
  late final IEditorPresenter presenter =
      GetScreen.of<IEditorPresenter>(context).presenter;

  @override
  void onMoveStart(DragStartDetails event, BoxConstraints constraints) {
    presenter.selectObject(widget);
    super.onMoveStart(event, constraints);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: DeferPointer(
            child: super.buildWidget(context),
          ),
        ),
        Positioned(
          left: -12,
          right: -12,
          top: -12,
          bottom: -12,
          child: ValueListenableBuilder(
            valueListenable: presenter.state.selectedObject,
            builder: (
              BuildContext context,
              EditorDraggableWidget? value,
              Widget? child,
            ) {
              final selected = value == widget;

              if (!selected) {
                return const SizedBox.shrink();
              }

              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -12,
                          left: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          top: -12,
                          left: -12 + constraints.maxWidth / 2,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          top: -12,
                          right: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          top: -12 + constraints.maxHeight / 2,
                          right: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          bottom: -12,
                          left: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          bottom: -12,
                          left: -12 + constraints.maxWidth / 2,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          bottom: -12,
                          right: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                        Positioned(
                          top: -12 + constraints.maxHeight / 2,
                          left: -12,
                          child: EOHandleButton(
                            onDrag: () {},
                            child: const Icon(Icons.abc),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
