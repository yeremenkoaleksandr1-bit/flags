import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../../../presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';

class EmblemSceneObject extends DraggableGameObject<DraggableEmblemPart> {
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
    extends DraggableGameObjectState<DraggableEmblemPart, EmblemSceneObject> {
  IPuzzleCommonModePresenter get _presenter => widget.presenter;

  @override
  void initState() {
    super.initState();
    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      _presenter.emblemConfirmationView.show();
      _presenter.setFocusOnObject(this);
      _setConfirmationButtonsPosition();
    });
  }

  void _setConfirmationButtonsPosition() {
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      try {
        if (!_presenter.emblemConfirmationView.mounted ||
            !context.mounted ||
            !mounted) {
          return;
        }

        final scale = scaleConverter(scaleRx.value);
        final rect = (context.globalPaintBounds ?? Rect.zero);

        _presenter.emblemConfirmationView.setPosition(
          rect.topLeft.translate(0, -52 * scale),
        );
        _presenter.emblemConfirmationView.setWidth(
          rect.width,
        );
      } catch (e) {}
    });
  }

  @override
  void onMoveStart(DragStartDetails event, BoxConstraints constraints) {
    _presenter.onObjectFocusAdded(this);
    _presenter.emblemConfirmationView.hide();
    super.onMoveStart(event, constraints);
  }

  @override
  void onMoveEnd(DragEndDetails event, BoxConstraints constraints) {
    _presenter.emblemConfirmationView.show();
    _setConfirmationButtonsPosition();

    super.onMoveEnd(event, constraints);
  }
}
