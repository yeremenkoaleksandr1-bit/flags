import 'package:armar/armar.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class BoardCommonItemWidget extends BoardItemWidget {
  const BoardCommonItemWidget({
    super.key,
    required super.presenter,
    required super.item,
    required this.flag,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
  });

  final GameFlag flag;

  final void Function(ProcessGameObject object)? onDragStarted;
  final void Function(ProcessGameObject object, DragUpdateDetails details)?
      onDragUpdate;
  final void Function(
          ProcessGameObject object, Velocity velocity, Offset offset)?
      onDraggableCanceled;
  final void Function(ProcessGameObject object, SDraggableDetails details)?
      onDragEnd;
  final void Function(ProcessGameObject object)? onDragCompleted;

  @override
  State<BoardCommonItemWidget> createState() => BoardCommonItemWidgetState();
}

class BoardCommonItemWidgetState<T extends BoardCommonItemWidget>
    extends BoardItemWidgetState<T> with SingleTickerProviderStateMixin {
  late final GlobalKey _key = GlobalKey();

  final RenderBoxExposer _exposer = RenderBoxExposer();
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  Widget buildChild(BuildContext context, BoxConstraints constraints) {
    final object = model.object;

    final transform = Matrix4.identity()
      ..rotateZ(object.rotation)
      ..scale(object.scale);

    Rect parentRect = Offset.zero & constraints.biggest;
    Rect transformedRect = MatrixUtils.transformRect(
      transform,
      parentRect,
    );

    double scaleX = parentRect.width / transformedRect.width;
    double scaleY = parentRect.height / transformedRect.height;
    double scaleToFit = scaleX < scaleY ? scaleX : scaleY;

    Matrix4 finalTransform = transform.clone()..scale(scaleToFit);

    return Transform(
      alignment: Alignment.center,
      transform: finalTransform,
      child: super.buildWidget(context, constraints),
    );
  }

  @override
  Widget buildWidget(BuildContext context, BoxConstraints constraints) {
    final boardItem = widget.item;
    final object = boardItem.object;

    final areaSize = presenter.flagExposer.renderBox.value?.size;

    final fitted = (areaSize?.width ?? 1) / (widget.flag.size.x);
    final objectSize = widget.item.object.size;

    final feedBackSize = widget.item.object.size.toSize() * fitted;

    final exposerSize =
        (_exposer.renderBox.value?.size ?? Size.zero).toVector2();

    return RenderBoxExposed(
      exposer: _exposer,
      child: SLongPressDraggable<ProcessGameObject>(
        key: _key,
        maxSimultaneousDrags: 1,
        delay: const Duration(milliseconds: 1),

        onDragStarted: () {
          _controller.forward(from: 0);
          widget.onDragStarted?.call(object);
        },
        onDragUpdate: (DragUpdateDetails details) {
          widget.onDragUpdate?.call(object, details);
        },
        onDragEnd: (SDraggableDetails details) {
          widget.onDragEnd?.call(object, details);
        },
        feedbackRect: Rect.fromLTWH(
          -feedBackSize.width / 2,
          -(feedBackSize.height + 4 * fitted),
          feedBackSize.width,
          feedBackSize.height,
        ),
        feedbackBuilder: (context, animation, setOffset) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              final isForwardAnimation =
                  !(animation.status == AnimationStatus.reverse);

              final renderBox = _key.currentContext!.renderBox;

              final globalPosition =
                  renderBox?.globalToLocal(Offset.zero) ?? Offset.zero;

              setOffset(
                (last) {
                  return last - (last + globalPosition) * (1 - animation.value);
                },
              );

              final widgetSize =
                  (exposerSize + objectSize * animation.value * fitted);

              widgetSize.clamp(objectSize, objectSize * fitted);

              final translateOffset = isForwardAnimation
                  ? ((Offset(
                            object.size.x / 2,
                            object.size.y / 2,
                          ) *
                          fitted) *
                      (1 - animation.value))
                  : Offset.zero;

              return Transform.translate(
                offset: translateOffset,
                child: SizedBox.fromSize(
                  size: widgetSize.toSize(),
                  child: child!,
                ),
              );
            },
            child: buildChild(context, constraints),
          );
        },
        data: widget.item.object,
        //  feedbackOffset: Offset(0, -object.size.y * fitted),
        dragAnchorStrategy: (
          SDraggable<Object> draggable,
          BuildContext context,
          Offset position,
        ) {
          return Offset(object.size.x / 2, object.size.y + 4) * fitted;
        },
        childWhenDragging: const SizedBox.shrink(),

        child: ConstrainedBox(
          constraints: constraints,
          child: buildChild(context, constraints),
        ),
      ),
    );
  }
}
