import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

class EmblemSceneObject extends DraggableGameObject<EmblemPart> {
  const EmblemSceneObject(
    super.gameObject,
    this.presenter, {
    super.key,
    super.onMoveStart,
    super.onMoveUpdate,
    super.onMoveEnd,
    super.onRenderBoxChanged,
    this.currentActiveWidget,
  });

  final DraggableGameObjectState? currentActiveWidget;

  final IPuzzleCommonModePresenter presenter;

  @override
  State<EmblemSceneObject> createState() => EmblemSceneObjectState();
}

class EmblemSceneObjectState
    extends DraggableGameObjectState<EmblemPart, EmblemSceneObject> {
  IPuzzleCommonModePresenter get _presenter => widget.presenter;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _presenter.emblemConfirmationView.show();
      _presenter.setFocusOnObject(this);
      _setConfirmationButtonsPosition();
    });
  }

  void _setConfirmationButtonsPosition() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_presenter.emblemConfirmationView.mounted) return;
      final rect = context.globalPaintBounds!;

      _presenter.emblemConfirmationView.setPosition(
        rect.topLeft,
      );
      _presenter.emblemConfirmationView.setWidth(
        rect.width,
      );
    });
  }

  @override
  void onMoveStart(MoveEvent event, BoxConstraints constraints) {
    _presenter.onObjectFocusAdded(this);
    _presenter.emblemConfirmationView.hide();
    super.onMoveStart(event, constraints);
  }

  @override
  void onMoveEnd(MoveEvent event, BoxConstraints constraints) {
    _presenter.emblemConfirmationView.show();
    _setConfirmationButtonsPosition();
    super.onMoveEnd(event, constraints);
  }
}
