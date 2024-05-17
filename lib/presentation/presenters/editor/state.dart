import 'package:flags/domain/editor/shapes/shapes.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/screens/editor/editor/object_handles/editor_draggable.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/foundation.dart';
import 'package:state_manager/state_manager.dart';

class EditorState implements IDisposable {
  final Map<String, FlagStyle> backgroundStyles;
  final Map<String, SShape> shapes;

  final ValueNotifier<FlagStyle> selectedStyle;

  final ValueNotifierList<EditorDraggableWidget> sceneObjects =
      ValueNotifierList();

  final ValueNotifier<EditorDraggableWidget?> selectedObject =
      ValueNotifier(null);

  EditorState({
    required this.backgroundStyles,
    required this.shapes,
    required this.selectedStyle,
  });

  @override
  void dispose() {
    selectedStyle.dispose();
    sceneObjects.dispose();
    selectedObject.dispose();
  }
}
