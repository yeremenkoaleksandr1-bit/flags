import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/actions/actions.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

part 'scene_objects_state.dart';

final class EditorSceneObjectsCubit extends Cubit<EditorSceneObjectsState>
    with SceneObjectsActionsMixin {
  final IFlagEditorCubit editorCubit;

  EditorSceneObjectsCubit({
    required this.editorCubit,
  }) : super(
          EditorSceneObjectsState([
            ...editorCubit.initialFlag.objects.map(EditorDraggableWidget.new),
          ]),
        );

  EditorDraggableWidget? updateGameObject(GameObject object) {
    final objects = [...state.objects];
    final index =
        objects.indexWhere((e) => object.uniqueName == e.gameObject.uniqueName);

    if (index != -1) {
      final newObject = EditorDraggableWidget(object);

      objects.removeAt(index);
      objects.insert(index, newObject);
      emit(
        state.copyWith(
          objects: objects,
        ),
      );

      return newObject;
    }
    return null;
  }

  void addGameObject(GameObject object) {
    final center = editorCubit.initialFlag.rect.center;


    object.position = Vector2(
      center.dx - object.size.x / 2,
      center.dy - object.size.y / 2,
    );


    emit(
      state.copyWith(
        objects: [
          ...state.objects,
          EditorDraggableWidget(object),
        ],
      ),
    );
  }

  void addGameObjects(List<GameObject> objects) {
    emit(
      state.copyWith(
        objects: [
          ...state.objects,
          ...objects.map(EditorDraggableWidget.new),
        ],
      ),
    );
  }
}
