import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../entities/entities.dart';

typedef SDragTargetWillAccept<T> = bool Function(T? data);

typedef SDragTargetWillAcceptWithDetails<T> = bool Function(
  SDragTargetDetails<T> details,
);

typedef SDragTargetAccept<T> = void Function(
  T data,
);

typedef SDragTargetAcceptWithDetails<T> = bool Function(
  SDragTargetDetails<T> details,
);

typedef SDragTargetBuilder<T> = Widget Function(
  BuildContext context,
  List<T?> candidateData,
  List<dynamic> rejectedData,
);

typedef SDragUpdateCallback = void Function(
  Offset globalPosition,
);

typedef SDraggableCanceledCallback = void Function(
  Velocity velocity,
  Offset offset,
);

typedef SDragEndCallback = void Function(
  SDraggableDetails details,
);

typedef SDragTargetLeave<T> = void Function(T? data);

typedef SDragTargetMove<T> = void Function(
  SDragTargetDetails<T> details,
);

typedef SDragAnchorStrategy = Offset Function(
  SDraggable<Object> draggable,
  BuildContext context,
  Offset position,
);

typedef SFeedbackBuilder = Widget Function(
  BuildContext context,
  AnimationController controller,
  RenderBox renderBox,
);

Offset childDragAnchorStrategy(
  SDraggable<Object> draggable,
  BuildContext context,
  Offset position,
) {
  RenderBox? renderBox = context.findRenderObject() as RenderBox?;

  return renderBox?.globalToLocal(position) ?? Offset.zero;
}

class SDraggable<T extends Object> extends StatefulWidget {
  const SDraggable({
    super.key,
    this.data,
    required this.child,
    this.ignoringFeedbackSemantics = true,
    this.ignoringFeedbackPointer = true,
    this.rootOverlay = true,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.allowedButtonsFilter,
    this.maxSimultaneousDrags,
    required this.feedbackRect,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragCompleted,
    this.onDragEnd,
    required this.feedbackBuilder,
    this.childWhenDragging,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationReverseDuration = const Duration(milliseconds: 150),
  });

  final T? data;

  final Widget? childWhenDragging;

  final Widget child;

  final SFeedbackBuilder feedbackBuilder;

  final Rect feedbackRect;

  final SDragAnchorStrategy dragAnchorStrategy;

  final bool ignoringFeedbackSemantics;

  final bool ignoringFeedbackPointer;

  final Axis? affinity;

  final int? maxSimultaneousDrags;

  final ValueChanged<Offset>? onDragStarted;

  final SDragUpdateCallback? onDragUpdate;

  final SDraggableCanceledCallback? onDraggableCanceled;

  final VoidCallback? onDragCompleted;

  final SDragEndCallback? onDragEnd;

  final bool rootOverlay;

  final HitTestBehavior hitTestBehavior;

  final AllowedButtonsFilter? allowedButtonsFilter;

  final Duration animationDuration;
  final Duration animationReverseDuration;

  @protected
  MultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    return ImmediateMultiDragGestureRecognizer(
      allowedButtonsFilter: allowedButtonsFilter,
    )..onStart = onStart;
  }

  @override
  State<SDraggable<T>> createState() => SDraggableState<T>();
}

class SDraggableState<T extends Object> extends State<SDraggable<T>> {
  @override
  void initState() {
    super.initState();
    _recognizer = widget.createRecognizer(_startDrag);
  }

  @override
  void dispose() {
    _disposeRecognizerIfInactive();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _recognizer!.gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
    super.didChangeDependencies();
  }

  GestureRecognizer? _recognizer;
  int _activeCount = 0;

  void _disposeRecognizerIfInactive() {
    if (_activeCount > 0) {
      return;
    }
    _recognizer!.dispose();
    _recognizer = null;
  }

  void _routePointer(PointerDownEvent event) {
    if (widget.maxSimultaneousDrags != null &&
        _activeCount >= widget.maxSimultaneousDrags!) {
      return;
    }
    _recognizer!.addPointer(event);
  }

  SDragAvatar<T>? _startDrag(Offset position) {
    if (widget.maxSimultaneousDrags != null &&
        _activeCount >= widget.maxSimultaneousDrags!) {
      return null;
    }
    final Offset dragStartPoint;
    dragStartPoint = widget.dragAnchorStrategy(widget, context, position);
    setState(() {
      _activeCount += 1;
    });
    final SDragAvatar<T> avatar = SDragAvatar<T>(
      widgetKey: widget.key,
      overlayState: Overlay.of(
        context,
        debugRequiredFor: widget,
        rootOverlay: widget.rootOverlay,
      ),
      data: widget.data,
      initialPosition: position,
      dragStartPoint: dragStartPoint,
      feedbackBuilder: widget.feedbackBuilder,
      feedbackRect: widget.feedbackRect,
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      ignoringFeedbackPointer: widget.ignoringFeedbackPointer,
      viewId: View.of(context).viewId,
      onDragUpdate: (details) {
        if (mounted && widget.onDragUpdate != null) {
          widget.onDragUpdate!(details);
        }
      },
      onDragEnd: (Velocity velocity, Offset offset, bool wasAccepted) {
        if (mounted) {
          setState(() {
            _activeCount -= 1;
          });
        } else {
          _activeCount -= 1;
          _disposeRecognizerIfInactive();
        }
        if (mounted && widget.onDragEnd != null) {
          widget.onDragEnd!(
            SDraggableDetails(
              wasAccepted: wasAccepted,
              velocity: velocity,
              offset: offset,
            ),
          );
        }
        if (wasAccepted && widget.onDragCompleted != null) {
          widget.onDragCompleted!();
        }
        if (!wasAccepted && widget.onDraggableCanceled != null) {
          widget.onDraggableCanceled!(velocity, offset);
        }
      },
      animationDuration: widget.animationDuration,
      animationReverseDuration: widget.animationReverseDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onDragStarted?.call(dragStartPoint);
    });
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));
    final bool canDrag = widget.maxSimultaneousDrags == null ||
        _activeCount < widget.maxSimultaneousDrags!;
    final bool showChild =
        _activeCount == 0 || widget.childWhenDragging == null;
    return Listener(
      behavior: widget.hitTestBehavior,
      onPointerDown: canDrag ? _routePointer : null,
      child: showChild ? widget.child : widget.childWhenDragging,
    );
  }
}
