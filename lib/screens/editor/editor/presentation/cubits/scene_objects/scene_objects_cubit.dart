import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';

part 'scene_objects_state.dart';

final class EditorSceneObjectsCubit extends Cubit<EditorSceneObjectsState> {
  EditorSceneObjectsCubit({
    required List<GameObject> initialObjects,
  }) : super(
          EditorSceneObjectsState([
            ...initialObjects.map(EditorDraggableWidget.new),
          ]),
        );

  void addGameObject(GameObject object) {
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
