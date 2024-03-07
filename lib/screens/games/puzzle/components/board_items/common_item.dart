import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../presentation/game/puzzle/entities/scallable_emblem.dart';
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
  final void Function(
    ProcessGameObject object,
    DragUpdateDetails details,
  )? onDragUpdate;
  final void Function(
    ProcessGameObject object,
    Velocity velocity,
    Offset offset,
  )? onDraggableCanceled;
  final void Function(
    ProcessGameObject object,
    SDraggableDetails details,
  )? onDragEnd;
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
    final object = model.object;

    final areaSize = presenter.flagExposer.renderBox.value?.size;

    var fitted = ((areaSize?.width ?? 1) / (widget.flag.size.x));

    final exposerSize =
        (_exposer.renderBox.value?.size ?? Size.zero).toVector2();

    final matrix = Matrix4.identity()
      ..translate(object.size.x / 2, object.size.y / 2)
      ..scale(fitted)
      ..rotateZ(object.rotation)
      ..scale(object.scale)
      ..translate(-object.size.x / 2, -object.size.y / 2);

    final feedback = MatrixUtils.transformRect(
      matrix.clone()..rotateZ(-object.rotation),
      (Vector2.zero() & object.size),
    );

    var feedBackRect = Rect.fromLTWH(
      -feedback.width / 2,
      -(feedback.height),
      feedback.width,
      feedback.height,
    );

    feedBackRect = MatrixUtils.transformRect(
      Matrix4.identity(),
      feedBackRect,
    );

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
        feedbackRect: feedBackRect,
        dragAnchorStrategy: (
          SDraggable<Object> draggable,
          BuildContext context,
          Offset position,
        ) {
          return MatrixUtils.transformPoint(
            matrix.clone()
              ..translate(object.size.x / 2, object.size.y / 2)
              ..rotateZ(-object.rotation)
              ..translate(-object.size.x / 2, -object.size.y / 2),
            Offset(object.size.x / 2, object.size.y),
          );
        },
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

              return Transform(
                transform: matrix,
                child: child!,
              );
            },
            child: super.buildWidget(context, constraints),
          );
        },
        data: widget.item.object,
        childWhenDragging: const SizedBox.shrink(),
        child: ConstrainedBox(
          constraints: constraints,
          child: buildChild(context, constraints),
        ),
      ),
    );
  }
}
