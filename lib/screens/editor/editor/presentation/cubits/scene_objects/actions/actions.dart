import 'package:flags/core/extensions/list.dart';
import 'package:flags/domain/game_objects/base/flippable.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SceneObjectsActionsMixin on Cubit<EditorSceneObjectsState> {
  int _getIndex(GameObject object) =>
      state.objects.indexWhere((e) => e.gameObject == object);

  EditorDraggableWidget? duplicate(GameObject object) {
    final index = _getIndex(object);

    if (index != -1) {
      final newObject = EditorDraggableWidget(
        object.copyWith(
          key: UniqueKey(),
        ),
      );

      final newObjects = [...state.objects]..insert(
          index + 1,
          newObject,
        );

      emit(
        state.copyWith(
          objects: newObjects,
        ),
      );

      return newObject;
    }

    return null;
  }

  void flipHorizontal(FlippableGameObject object) {
    object.flipHorizontal();
    print(object.flippedHorizontal);
  }

  void flipVertical(FlippableGameObject object) {}

  void layerUp(GameObject object) {
    final index = _getIndex(object);

    if (index >= 0 && index < state.objects.length - 1) {
      _updateState(
        (objects) {
          final newObjects = [...objects];
          newObjects.swap(index + 1, index);
          return newObjects;
        },
      );
    }
  }

  void layerDown(GameObject object) {
    final index = _getIndex(object);

    if (index < state.objects.length && index > 0) {
      _updateState(
        (objects) {
          final newObjects = [...objects];
          newObjects.swap(index - 1, index);
          return newObjects;
        },
      );
    }
  }

  void removeObject(GameObject object) {
    _updateState(
      (objects) => [...objects]..removeWhere(
          (e) => e.gameObject == object,
        ),
    );
  }

  void _updateState(
    List<EditorDraggableWidget> Function(
      List<EditorDraggableWidget> objects,
    ) func,
  ) {
    emit(
      state.copyWith(
        objects: func([...state.objects]),
      ),
    );
  }
}
