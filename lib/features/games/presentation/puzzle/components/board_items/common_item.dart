import 'dart:ui';

import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/games/presentation/puzzle/components/board_items/base.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardCommonItemWidget extends BoardItemWidget {
  const BoardCommonItemWidget({
    super.key,
    required super.cubit,
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
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

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

  Widget buildChild(
    BuildContext context,
    BoxConstraints constraints,
    BoardItem item,
  ) {
    final object = model.object;

    final transform = Matrix4.identity()
      ..rotateZ(object.rotation)
      ..scale(object.scale);

    final Rect parentRect = Offset.zero & constraints.biggest;
    final Rect transformedRect = MatrixUtils.transformRect(
      transform,
      parentRect,
    );

    final double scaleX = parentRect.width / transformedRect.width;
    final double scaleY = parentRect.height / transformedRect.height;
    final double scaleToFit = scaleX < scaleY ? scaleX : scaleY;

    final Matrix4 finalTransform = transform.clone()..scale(scaleToFit);

    return Transform(
      alignment: Alignment.center,
      transform: finalTransform,
      child: super.buildWidget(context, constraints, item),
    );
  }

  final ValueNotifier<Offset> _feedbackPosition = ValueNotifier(Offset.zero);

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.item != widget.item) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _feedbackPosition.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(
    BuildContext context,
    BoxConstraints constraints,
    BoardItem item,
  ) {
    final object = item.object;

    final areaSize = presenter.flagExposer.renderBox.value?.size;

    final areaWidth = areaSize?.width ?? 1;
    final fitted = areaWidth / (widget.flag.size.x);

    final matrix = Matrix4.identity()
      ..translate(object.size.x / 2, object.size.y / 2)
      ..scale(fitted)
      ..rotateZ(object.rotation)
      ..scale(object.scale)
      ..translate(-object.size.x / 2, -object.size.y / 2);

    final feedback = MatrixUtils.transformRect(
      matrix.clone()..rotateZ(-object.rotation),
      Vector2.zero() & object.size,
    );

    var feedBackRect = Rect.fromLTWH(
      -feedback.width / 2,
      -feedback.height,
      feedback.width,
      feedback.height,
    );

    feedBackRect = MatrixUtils.transformRect(
      Matrix4.identity(),
      feedBackRect,
    );

    return RenderBoxExposed(
      exposer: _exposer,
      child: Builder(
        builder: (context) {
          return SLongPressDraggable<ProcessGameObject>(
            key: _key,
            maxSimultaneousDrags: 1,
            delay: const Duration(milliseconds: 1),
            onDragStarted: (dragStartPoint) {
              try {
                final showcase = widget.cubit.showcase;
                if (!showcase.isCompleted("puzzle_common_object")) {
                  showcase.showcaseState.next();
                  showcase.complete("puzzle_common_object");
                } else if (!showcase.isCompleted("puzzle_emblem_object")) {
                  showcase.showcaseState.next();
                }
              } catch (e) {}

              _feedbackPosition.value = dragStartPoint;
              _controller.forward(from: 0);
              widget.onDragStarted?.call(object);
            },
            onDragUpdate: (Offset globalPosition) {
              _feedbackPosition.value = globalPosition;

              widget.onDragUpdate?.call(
                object,
                DragUpdateDetails(
                  globalPosition: globalPosition,
                ),
              );

              // DebugPainter.paint((canvas, size) {
              //   canvas.drawPoints(
              //     PointMode.points,
              //     [
              //       feedBackRect.topLeft,
              //       feedBackRect.topRight,
              //       feedBackRect.topCenter,
              //       feedBackRect.bottomLeft,
              //       feedBackRect.bottomCenter,
              //       feedBackRect.bottomRight,
              //       feedBackRect.centerLeft,
              //       feedBackRect.centerRight,
              //     ].map((e) => globalPosition + e).toList(),
              //     Paint()
              //       ..color = Colors.red
              //       ..strokeWidth = 4
              //       ..strokeCap = StrokeCap.round,
              //   );
              // });
            },
            onDragEnd: (SDraggableDetails details) {
              widget.onDragEnd?.call(object, details);
            },
            onDragCanceled: () =>
                audioCubit.playSfx(GameSfx.cancelObjectPlacing),
            feedbackRect: feedBackRect,
            dragAnchorStrategy: (
              SDraggable<Object> draggable,
              BuildContext context,
              Offset position,
            ) {
              return position;
            },
            feedbackBuilder: (context, renderBox) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  final value = _controller.value;

                  final renderBox =
                      _key.currentContext!.findRenderObject()! as RenderBox;

                  final rect = renderBox.rect;

                  final position = rect.center.toVector2();

                  final double scale = lerpDouble(
                    1,
                    object.scale,
                    value,
                  )!;

                  return ValueListenableBuilder(
                    valueListenable: _feedbackPosition,
                    builder: (
                      BuildContext context,
                      Offset value,
                      Widget? child,
                    ) {
                      position.lerp(
                        value.toVector2(),
                        _controller.value,
                      );

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            position.x,
                            position.y,
                          )
                          ..translate(-object.size.x / 2, -object.size.y / 2)
                          ..scale(scale)
                          ..scale(fitted)
                          ..translate2(
                            Vector2(0, -object.size.y / 2),
                          ),
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateZ(object.rotation),
                  child: super.buildWidget(
                    context,
                    constraints,
                    item,
                  ),
                ),
              );
            },
            data: widget.item.object,
            childWhenDragging: const SizedBox.expand(),
            child: Builder(
              key: ValueKey(item.hashCode),
              builder: (context) {
                return ConstrainedBox(
                  constraints: constraints,
                  child: buildChild(
                    context,
                    constraints,
                    item,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
