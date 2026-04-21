import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flame/extensions.dart' hide Matrix4;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorObjectHandleGameObject extends GameObject {
  EditorObjectHandleGameObject({
    super.key,
    super.uniqueName,
    super.position,
    super.scale,
    super.size,
    super.rotation,
  }) : super(name: "editor_object_handle_game_object");

  @override
  GameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
  }) {
    return EditorObjectHandleGameObject(
      key: key ?? this.key,
      uniqueName: uniqueName ?? this.uniqueName,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  Future<void> init() async {}
}

class EditorObjectHandlerWidget
    extends DraggableGameObjectWidget<EditorObjectHandleGameObject> {
  EditorObjectHandlerWidget({
    super.key,
  }) : super(
          EditorObjectHandleGameObject(
            position: Vector2(-9999, -9999),
          ),
        );

  @override
  State<EditorObjectHandlerWidget> createState() =>
      EditorObjectHandleGameObjectState();
}

class EditorObjectHandleGameObjectState<T extends EditorObjectHandlerWidget>
    extends DraggableGameObjectWidgetState<EditorObjectHandleGameObject, T> {
  late final bloc = context.read<IFlagEditorCubit>();

  @override
  void initState() {
    bloc.selectedObject.addListener(_listenGameObjectSelection);
    super.initState();
  }

  @override
  Rect transformRect({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) {
    return MatrixUtils.transformRect(
      Matrix4.identity()
        ..translate(position.x, position.y)
        ..translate(size.x / 2, size.y / 2)
        ..scale(scale * 1.2)
        ..translate(-size.x / 2, -size.y / 2),
      Vector2.zero() & size,
    );
  }

  @override
  Matrix4 transformationMatrix({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) {
    return Matrix4.identity();
  }

  EditorDraggableWidget? _lastSelected;

  void _listenGameObjectSelection() {
    setState(() {});
  }

  @override
  Widget buildDraggableWidget(
      BuildContext context, EditorObjectHandleGameObject gameObject) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: super.buildDraggableWidget(context, gameObject),
    );
  }
}
