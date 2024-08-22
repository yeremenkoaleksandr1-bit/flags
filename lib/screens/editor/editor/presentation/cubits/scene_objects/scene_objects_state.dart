part of 'scene_objects_cubit.dart';

final class EditorSceneObjectsState extends Equatable {
  final List<EditorDraggableWidget> objects;

  const EditorSceneObjectsState(this.objects);

  EditorSceneObjectsState copyWith({
    List<EditorDraggableWidget>? objects,
  }) {
    return EditorSceneObjectsState(
      objects ?? this.objects,
    );
  }

  @override
  List<Object?> get props => [objects];
}
