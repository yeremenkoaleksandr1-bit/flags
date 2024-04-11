import 'package:armar/state_management/get.dart';
import 'package:flags/domain/editor/shapes/shapes.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/screens/editor/editor/object_handles/editor_draggable.dart';

class EditorState {
  final Map<String, FlagStyle> backgroundStyles;
  final Map<String, SShape> shapes;

  final RxValue<FlagStyle> selectedStyle;

  final RxList<EditorDraggableWidget> sceneObjects = RxList([]);

  final RxValue<EditorDraggableWidget?> selectedObject = RxValue(null);

  EditorState({
    required this.backgroundStyles,
    required this.shapes,
    required this.selectedStyle,
  });
}
