import 'package:drag_and_drop/components/drag_target_area.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:widget_finder/widget_finder.dart';

import '../components/draggable.dart';
import '../enums/drag_end_kind.dart';

typedef _OnDragEnd = void Function(
  Velocity velocity,
  Offset offset,
  bool wasAccepted,
);

class SDragAvatar<T extends Object> extends Drag {
  SDragAvatar({
    this.widgetKey,
    required this.overlayState,
    this.data,
    required Offset initialPosition,
    this.dragStartPoint = Offset.zero,
    required this.feedbackBuilder,
    required this.feedbackRect,
    this.onDragUpdate,
    this.onDragEnd,
    required this.ignoringFeedbackSemantics,
    required this.ignoringFeedbackPointer,
    required this.viewId,
    required this.animationDuration,
    required this.animationReverseDuration,
  }) : _position = initialPosition {
    _entry = OverlayEntry(builder: _build);
    overlayState.insert(_entry!);
    updateDrag(initialPosition);
    _animationController = AnimationController(
      duration: animationDuration,
      reverseDuration: animationReverseDuration,
      vsync: overlayState,
    );

    if (widgetKey is GlobalKey) {
      widgetOffset = WidgetFinder.of(widgetKey as GlobalKey).topLeft;
    }

    _animationController.forward();
  }

  final T? data;

  final Key? widgetKey;

  final Offset dragStartPoint;

  final SFeedbackBuilder feedbackBuilder;

  final Rect feedbackRect;

  final SDragUpdateCallback? onDragUpdate;

  final _OnDragEnd? onDragEnd;

  final OverlayState overlayState;

  final bool ignoringFeedbackSemantics;

  final bool ignoringFeedbackPointer;

  final int viewId;

  late AnimationController _animationController;
  final Duration animationDuration;
  final Duration animationReverseDuration;

  SDragTargetAreaState<Object>? _activeTarget;

  final List<SDragTargetAreaState<Object>> _enteredTargets =
      <SDragTargetAreaState<Object>>[];

  Offset _position;
  Offset _lastOffset = Offset.zero;
  Offset _finalLastPosition = Offset.zero;

  Offset get lastOffset => _lastOffset;

  Offset get position => _position;

  Offset get finalLastPosition => _finalLastPosition;

  OverlayEntry? _entry;

  Offset widgetOffset = Offset.zero;

  bool _dragStarted = false;

  @override
  void update(DragUpdateDetails details) {
    final Offset oldPosition = _position;
    _position += _restrictAxis(details.delta);
    updateDrag(_position);
    if (onDragUpdate != null && _position != oldPosition) {
      onDragUpdate!(details);
    }
  }

  @override
  void end(DragEndDetails details) {
    finishDrag(
      SDragEndKind.dropped,
      _restrictVelocityAxis(details.velocity),
    );
  }

  @override
  void cancel() {
    finishDrag(SDragEndKind.canceled);
  }

  late final _feedBackPoints = [
    feedbackRect.topLeft,
    feedbackRect.topCenter,
    feedbackRect.topRight,
    feedbackRect.center,
    feedbackRect.centerLeft,
    feedbackRect.centerRight,
    feedbackRect.bottomLeft,
    feedbackRect.bottomCenter,
    feedbackRect.bottomRight,
  ];

  void updateDrag(Offset globalPosition) {
    if (!_dragStarted) {
      _dragStarted =
          (globalPosition - dragStartPoint) - _finalLastPosition != Offset.zero;
    }
    _lastOffset = globalPosition - dragStartPoint;
    _finalLastPosition = _lastOffset;
    _entry!.markNeedsBuild();
    final HitTestResult result = HitTestResult();

    if (_dragStarted) {
      for (var e in _feedBackPoints) {
        WidgetsBinding.instance.hitTestInView(
          result,
          globalPosition + e,
          viewId,
        );
      }
    }

    final List<SDragTargetAreaState<Object>> targets = [
      ..._getDragTargets(result.path)
    ];

    bool listsMatch = _enteredTargets.isNotEmpty &&
        targets.length >= _enteredTargets.length &&
        _enteredTargets
            .asMap()
            .entries
            .every((entry) => entry.value == targets[entry.key]);

    // If everything's the same, report moves, and bail early.
    if (listsMatch) {
      for (final SDragTargetAreaState<Object> target in _enteredTargets) {
        target.didMove(this);
      }
      return;
    }

    // Leave old targets.
    _leaveAllEntered();

    // Enter new targets.
    final newTarget = targets.cast<SDragTargetAreaState<Object>?>().where(
      (target) {
        if (target == null) {
          return false;
        }

        _enteredTargets.add(target);
        return target.didEnter(this);
      },
    ).firstOrNull;

    // Report moves to the targets.
    for (final SDragTargetAreaState<Object> target in _enteredTargets) {
      target.didMove(this);
    }

    _activeTarget = newTarget;
  }

  Iterable<SDragTargetAreaState<Object>> _getDragTargets(
    Iterable<HitTestEntry> path,
  ) {
    // Look for the RenderBoxes that corresponds to the hit target (the hit target
    // widgets build RenderMetaData boxes for us for this purpose).
    final List<SDragTargetAreaState<Object>> targets =
        <SDragTargetAreaState<Object>>[];
    for (final HitTestEntry entry in path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData) {
        final dynamic metaData = target.metaData;

        if (metaData is SDragTargetAreaState &&
            metaData.isExpectedDataType(data, T)) {
          targets.add(metaData);
        }
      }
    }
    return targets;
  }

  void _leaveAllEntered() {
    for (int i = 0; i < _enteredTargets.length; i += 1) {
      _enteredTargets[i].didLeave(this);
    }
    _enteredTargets.clear();
  }

  void finishDrag(SDragEndKind endKind, [Velocity? velocity]) async {
    bool wasAccepted = false;

    if (endKind == SDragEndKind.dropped && _activeTarget != null) {
      wasAccepted = _activeTarget!.didDrop(this);
      _enteredTargets.remove(_activeTarget);
    }

    if (!wasAccepted) await animateToInitialPosition();

    onDragEnd?.call(
      velocity ?? Velocity.zero,
      _lastOffset,
      wasAccepted,
    );

    _leaveAllEntered();
    _activeTarget = null;
    _entry!.remove();
    _entry!.dispose();
    _entry = null;

    _animationController.dispose();
  }

  Future<void> animateToInitialPosition() async {
    _animationController.addListener(() {
      _entry!.markNeedsBuild();
    });

    await _animationController.reverse();
  }

  Widget _build(BuildContext context) {
    final RenderBox box = overlayState.context.findRenderObject() as RenderBox;
    final Offset overlayTopLeft = box.localToGlobal(Offset.zero);

    return Positioned(
      left: _lastOffset.dx - overlayTopLeft.dx,
      top: _lastOffset.dy - overlayTopLeft.dy,
      child: ExcludeSemantics(
        excluding: ignoringFeedbackSemantics,
        child: IgnorePointer(
          ignoring: ignoringFeedbackPointer,
          child: feedbackBuilder(
            context,
            _animationController,
            (offset) {
              _lastOffset = offset(_finalLastPosition);
            },
          ),
        ),
      ),
    );
  }

  Velocity _restrictVelocityAxis(Velocity velocity) {
    return velocity;
  }

  Offset _restrictAxis(Offset offset) {
    return offset;
  }
}
