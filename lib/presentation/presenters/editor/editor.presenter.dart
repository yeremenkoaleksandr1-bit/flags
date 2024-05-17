import 'package:flags/core/features/qlevar.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/presentation/presenters/editor/factories/boards/shapes_board.dart';
import 'package:flags/presentation/presenters/editor/factories/boards/styles_board.dart';
import 'package:flags/presentation/presenters/editor/mixins/boards.dart';
import 'package:flags/presentation/presenters/editor/state.dart';
import 'package:flags/screens/editor/editor/object_handles/editor_draggable.dart';
import 'package:flutter/foundation.dart';
import 'package:state_manager/state_manager.dart';

abstract interface class IEditorPresenter
    with StateMixin<EditorState>
    implements IEditorBoardsMixin {
  EditorFlagData get flag;

  void selectBackgroundStyle(FlagStyle style);

  Future<void> addObjectToScene(GameObject object);

  Future<void> selectObject(EditorDraggableWidget? object);
}

class EditorPresenterImpl extends GetxController
    with StateMixin<EditorState>, QRContextMixin, EditorBoardsMixin
    implements IEditorPresenter {
  @override
  final EditorFlagData flag;

  EditorPresenterImpl(this.flag);

  @override
  Future<void> onInit() async {
    change(
      SuccessStatus(
        EditorState(
          backgroundStyles: StylesBoardFactory.create(flag.rect),
          shapes: ShapesBoardFactory.create(),
          selectedStyle: ValueNotifier(flag.backgroundStyle),
        ),
      ),
    );
    super.onInit();
  }

  @override
  void selectBackgroundStyle(FlagStyle style) {
    state.selectedStyle.value = style;
  }

  @override
  Future<void> addObjectToScene(GameObject object) async {
    state.sceneObjects.add(
      EditorDraggableWidget(object),
    );
  }

  @override
  Future<void> selectObject(EditorDraggableWidget? object) async {
    state.selectedObject.value = object;
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
