part of 'selected_object_cubit.dart';

final class EditorSelectedObjectState extends Equatable {
  final EditorDraggableWidget? object;

  const EditorSelectedObjectState({
    required this.object,
  });

  EditorSelectedObjectState copyWith({
    EditorDraggableWidget? object,
  }) {
    return EditorSelectedObjectState(
      object: object,
    );
  }

  @override
  List<Object?> get props => [object];
}
