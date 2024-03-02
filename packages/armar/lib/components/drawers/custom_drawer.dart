// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: use_build_context_synchronously

import 'package:armar/logger.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

const double _kWidth = 304.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class _DrawerControllerScope extends InheritedWidget {
  const _DrawerControllerScope({
    required this.controller,
    required super.child,
  });

  final ArDrawerController controller;

  @override
  bool updateShouldNotify(_DrawerControllerScope old) {
    return controller != old.controller;
  }
}

class ArDrawerController extends StatefulWidget {
  const ArDrawerController({
    GlobalKey? key,
    required this.child,
    required this.alignment,
    this.isDrawerOpen = false,
    this.drawerCallback,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrimColor,
    this.edgeDragWidth,
    this.enableOpenDragGesture = true,
    this.closingCondition,
  }) : super(key: key);

  final Widget child;

  final DrawerAlignment alignment;

  final DrawerCallback? drawerCallback;

  final DragStartBehavior dragStartBehavior;

  final Color? scrimColor;

  final bool enableOpenDragGesture;

  final double? edgeDragWidth;

  final bool isDrawerOpen;

  final Future<bool> Function()? closingCondition;

  static ArDrawerController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_DrawerControllerScope>()
        ?.controller;
  }

  static ArDrawerControllerState of<T>(BuildContext context) {
    ArDrawerControllerState? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<ArDrawerControllerState>();
    }

    assert(() {
      if (state == null) {
        throw FlutterError('Context does not include a GetScreenState.');
      }
      return true;
    }());

    return state!;
  }

  @override
  ArDrawerControllerState createState() => ArDrawerControllerState();
}

class ArDrawerControllerState extends State<ArDrawerController>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.isDrawerOpen ? 1.0 : 0.0,
      duration: _kBaseSettleDuration,
      vsync: this,
    );
    _controller
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrimColorTween = _buildScrimColorTween();
  }

  @override
  void didUpdateWidget(ArDrawerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrimColor != oldWidget.scrimColor) {
      _scrimColorTween = _buildScrimColorTween();
    }
    if (widget.isDrawerOpen != oldWidget.isDrawerOpen) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          _controller.value = widget.isDrawerOpen ? 1.0 : 0.0;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });
  }

  LocalHistoryEntry? _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(
            onRemove: _handleHistoryEntryRemoved,
            impliesAppBarDismissal: false);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _ensureHistoryEntry();
      case AnimationStatus.reverse:
        _historyEntry?.remove();
        _historyEntry = null;
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.completed:
        break;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    // close();
  }

  late AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
    _ensureHistoryEntry();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) {
      return;
    }
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    final RenderBox? box =
        _drawerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.size.width;
    }
    return _kWidth; // drawer not being shown currently
  }

  bool _previouslyOpened = false;

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta! / _width;
    switch (widget.alignment) {
      case DrawerAlignment.start:
        break;
      case DrawerAlignment.end:
        delta = -delta;
    }
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _controller.value -= delta;
      case TextDirection.ltr:
        _controller.value += delta;
    }

    final bool opened = _controller.value > 0.5;
    if (opened != _previouslyOpened && widget.drawerCallback != null) {
      widget.drawerCallback!(opened);
    }
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) async {
    if (_controller.isDismissed) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _width;
      switch (widget.alignment) {
        case DrawerAlignment.start:
          break;
        case DrawerAlignment.end:
          visualVelocity = -visualVelocity;
      }

      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _controller.fling(velocity: -visualVelocity);
          widget.drawerCallback?.call(visualVelocity < 0.0);
          isOpened = visualVelocity < 0.0;
        case TextDirection.ltr:
          if (visualVelocity < 0.0 &&
              widget.closingCondition != null &&
              !await widget.closingCondition!.call()) {
            _controller.fling(velocity: 1);
            widget.drawerCallback?.call(true);
            isOpened = true;
            return;
          }

          _controller.fling(velocity: visualVelocity);
          widget.drawerCallback?.call(visualVelocity > 0.0);
          isOpened = visualVelocity > 0.0;
      }
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  /// Starts an animation to open the drawer.
  ///
  /// Typically called by [ScaffoldState.openDrawer].
  void open() {
    _controller.fling();
    widget.drawerCallback?.call(true);
    isOpened = true;
  }

  /// Starts an animation to close the drawer.
  void close() async {
    if (widget.closingCondition != null &&
        !await widget.closingCondition!.call()) {
      _controller.fling(velocity: 1);
      widget.drawerCallback?.call(true);
      isOpened = true;
      return;
    }
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
    isOpened = false;
  }

  void forceClose() async {
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
    isOpened = false;
  }

  late ColorTween _scrimColorTween;
  final GlobalKey _gestureDetectorKey = GlobalKey();

  ColorTween _buildScrimColorTween() {
    return ColorTween(
      begin: Colors.transparent,
      end: widget.scrimColor ??
          DrawerTheme.of(context).scrimColor ??
          Colors.black54,
    );
  }

  AlignmentDirectional get _drawerOuterAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerStart;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  AlignmentDirectional get _drawerInnerAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerEnd;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerStart;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final bool drawerIsStart = widget.alignment == DrawerAlignment.start;
    final TextDirection textDirection = Directionality.of(context);
    final bool isDesktop;
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        isDesktop = false;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        isDesktop = true;
    }

    double? dragAreaWidth = widget.edgeDragWidth;
    if (widget.edgeDragWidth == null) {
      final EdgeInsets padding = MediaQuery.paddingOf(context);
      switch (textDirection) {
        case TextDirection.ltr:
          dragAreaWidth =
              _kEdgeDragWidth + (drawerIsStart ? padding.left : padding.right);
        case TextDirection.rtl:
          dragAreaWidth =
              _kEdgeDragWidth + (drawerIsStart ? padding.right : padding.left);
      }
    }

    final bool platformHasBackButton;
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        platformHasBackButton = true;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        platformHasBackButton = false;
    }

    final Widget child = Opacity(
      opacity: _controller.status == AnimationStatus.dismissed ? 0 : 1,
      child: _DrawerControllerScope(
        controller: widget,
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              IgnorePointer(
                ignoring: _controller.status == AnimationStatus.dismissed,
                child: BlockSemantics(
                  child: ExcludeSemantics(
                    // On Android, the back button is used to dismiss a modal.
                    excluding: platformHasBackButton,
                    child: GestureDetector(
                      onTap: close,
                      child: Container(
                        // The drawer's "scrim"
                        color: _scrimColorTween.evaluate(_controller),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: _drawerOuterAlignment,
                child: Align(
                  alignment: _drawerInnerAlignment,
                  widthFactor: _controller.value,
                  child: RepaintBoundary(
                    child: FocusScope(
                      key: _drawerKey,
                      node: _focusScopeNode,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              if (_controller.status == AnimationStatus.dismissed)
                SizedBox(
                  width: dragAreaWidth,
                  height: 1,
                ),
            ],
          ),
        ),
      ),
    );

    if (isDesktop) {
      return child;
    }

    return GestureDetector(
      key: _gestureDetectorKey,
      onHorizontalDragDown: _handleDragDown,
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      onHorizontalDragCancel: _handleDragCancel,
      excludeFromSemantics: true,
      dragStartBehavior: widget.dragStartBehavior,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {

    assert(debugCheckHasMaterialLocalizations(context));
    return _buildDrawer(context);
  }
}
