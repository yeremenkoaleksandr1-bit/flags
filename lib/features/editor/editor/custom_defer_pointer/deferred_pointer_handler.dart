part of 'defer_pointer.dart';

/// Handles paint and hit testing for descendant [EDeferPointer] widgets.
/// Deferred painting (aka 'paint on top') is optional and can be defined per [EDeferPointer].
class EDeferredPointerHandler extends StatefulWidget {
  const EDeferredPointerHandler({
    super.key,
    required this.child,
    this.link,
  });

  final Widget child;
  final EDeferredPointerHandlerLink? link;

  @override
  EDeferredPointerHandlerState createState() => EDeferredPointerHandlerState();

  /// The state from the closest instance of this class that encloses the given context.
  static EDeferredPointerHandlerState of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_InheritedDeferredPaintSurface>();
    assert(
      inherited != null,
      'DeferredPaintSurface was not found on this context.',
    );
    return inherited!.state;
  }
}

/// Holds an internal [EDeferredPointerHandlerLink] which can be found using
/// [EDeferredPointerHandler].of(context).link.
/// Also accepts an external link which will be used instead of the internal one.
class EDeferredPointerHandlerState extends State<EDeferredPointerHandler> {
  final EDeferredPointerHandlerLink _link = EDeferredPointerHandlerLink();

  EDeferredPointerHandlerLink get link => _link;

  @override
  void didUpdateWidget(covariant EDeferredPointerHandler oldWidget) {
    if (widget.link != null) {
      _link.removeAll();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDeferredPaintSurface(
      state: this,
      child: _DeferredHitTargetRenderObjectWidget(
        link: widget.link ?? _link,
        child: widget.child,
      ),
    );
  }
}

////////////////////////////////
// RENDER OBJECT WIDGET

class _DeferredHitTargetRenderObjectWidget
    extends SingleChildRenderObjectWidget {
  const _DeferredHitTargetRenderObjectWidget({
    required this.link,
    super.child,
  });

  final EDeferredPointerHandlerLink link;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _DeferredHitTargetRenderObject(link);

  @override
  void updateRenderObject(
    BuildContext context,
    _DeferredHitTargetRenderObject renderObject,
  ) =>
      renderObject.link = link;
}

////////////////////////////////
// RENDER OBJECT PAINTER

class _DeferredHitTargetRenderObject extends RenderProxyBox {
  _DeferredHitTargetRenderObject(
    EDeferredPointerHandlerLink link, [
    RenderBox? child,
  ]) : super(child) {
    this.link = link;
  }

  EDeferredPointerHandlerLink? _link;

  EDeferredPointerHandlerLink get link => _link!;

  set link(EDeferredPointerHandlerLink link) {
    if (_link != null) {
      _link!.removeListener(markNeedsPaint);
    }
    _link = link;
    this.link.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    for (final painter in link.painters.reversed) {
      final hit = result.addWithPaintTransform(
        transform: painter.child!.getTransformTo(this),
        position: position,
        hitTest: (BoxHitTestResult result, Offset? position) {
          return painter.child!.hitTest(result, position: position!);
        },
      );
      if (hit) {
        return true;
      }
    }
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  // paint all the children that want to be rendered on top
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    for (final painter in link.painters) {
      if (painter.deferPaint == false) {
        continue;
      }
      context.paintChild(
        painter.child!,
        painter.child!.localToGlobal(Offset.zero, ancestor: this) + offset,
      );
    }
  }
}

////////////////////////////////
// INHERITED WIDGET

class _InheritedDeferredPaintSurface extends InheritedWidget {
  const _InheritedDeferredPaintSurface({
    required super.child,
    required this.state,
  });

  final EDeferredPointerHandlerState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
