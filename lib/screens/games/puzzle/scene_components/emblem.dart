import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flutter/widgets.dart';

class EmblemSceneObject extends DraggableGameObjectWidget<DraggableEmblemPart> {
  EmblemSceneObject(
    super.gameObject,
    this.presenter, {
    super.key,
    super.onMoveStart,
    super.onMoveUpdate,
    super.onMoveEnd,
    super.onRenderBoxChanged,
    this.currentActiveWidget,
  });

  final DraggableGameObjectWidgetState? currentActiveWidget;

  final IPuzzleCommonModePresenter presenter;

  @override
  State<EmblemSceneObject> createState() => EmblemSceneObjectState();
}

class EmblemSceneObjectState extends DraggableGameObjectWidgetState<
    DraggableEmblemPart, EmblemSceneObject> {
  IPuzzleCommonModePresenter get presenter => widget.presenter;

  @override
  void initState() {
    super.initState();
    FlutterEngine.widgetPostFrameCallback((timeStamp) async {
      presenter.emblemConfirmationView.show();
      presenter.setFocusOnObject(this);
      _setConfirmationButtonsPosition();

      if (presenter is! IPuzzleFastModePresenter) {
        await Future.delayed(const Duration(milliseconds: 101));
        FlutterEngine.schedulePostFrameCallback((timeStamp) {
          presenter.showcase.show(
            [presenter.showcase.emblemObjectStep2],
            "puzzle_emblem_object",
          );
        });
      }
    });
  }

  void _setConfirmationButtonsPosition() {
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      try {
        if (!presenter.emblemConfirmationView.mounted ||
            !context.mounted ||
            !mounted) {
          return;
        }

        final scale = scaleConverter(gameObject.scale);
        final rect = context.globalPaintBounds ?? Rect.zero;

        presenter.emblemConfirmationView.setPosition(
          rect.topLeft.translate(0, -52 * scale),
        );
        presenter.emblemConfirmationView.setWidth(
          rect.width,
        );
      } catch (e) {}
    });
  }

  @override
  void onMoveStart(event, BoxConstraints constraints) {
    presenter.onObjectFocusAdded(this);
    presenter.emblemConfirmationView.hide();
    super.onMoveStart(event, constraints);
  }

  @override
  void onMoveEnd(event, BoxConstraints constraints) {
    presenter.emblemConfirmationView.show();
    _setConfirmationButtonsPosition();

    super.onMoveEnd(event, constraints);
  }
}
