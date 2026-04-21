import 'package:auto_route/auto_route.dart';
import 'package:flags/navigator/game_navigation_observer.dart';
import 'package:flutter/material.dart';

enum GamePageSlideDirection { top, bottom, left, right, middle }

class GamePageBuilder extends StatefulWidget {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const GamePageBuilder({
    super.key,
    required this.child,
    this.startSlideDirection = GamePageSlideDirection.right,
    this.endSlideDirection = GamePageSlideDirection.left,
    this.curve = Curves.linear,
    this.onPageFocussed,
    this.onPageUnfocused,
    this.transitionDuration = const Duration(milliseconds: 250),
  });

  final Widget child;

  final GamePageSlideDirection startSlideDirection;
  final GamePageSlideDirection endSlideDirection;

  final Curve curve;

  final VoidCallback? onPageFocussed;
  final VoidCallback? onPageUnfocused;

  final Duration transitionDuration;

  @override
  State<GamePageBuilder> createState() => _GamePageBuilderState();
}

class _GamePageBuilderState extends State<GamePageBuilder>
    with AutoRouteAware, RouteAware, SingleTickerProviderStateMixin
    implements PopEntry<GamePageBuilder> {
  late final AnimationController _controller;
  GameAutoRouteObserver? _observer;
  ModalRoute<dynamic>? _route;

  @override
  late final ValueNotifier<bool> canPopNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    _controller.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? nextRoute = ModalRoute.of(context);

    if (nextRoute != _route) {
      _route?.unregisterPopEntry(this);
      _route = nextRoute;
      _route?.registerPopEntry(this);
    }

    final routeDataScope = context
        .findAncestorWidgetOfExactType<RouteDataScope>();

    if (routeDataScope != null) {
      _observer = RouterScope.of(
        context,
      ).firstObserverOfType<GameAutoRouteObserver>();
      if (_observer != null) {
        _observer!.subscribe(this, context.routeData);
      }
    } else {
      if (_route != null) {
        GamePageBuilder.routeObserver.subscribe(this, _route!);
      }
    }
  }

  @override
  void onPopInvoked(bool didPop) {}

  @override
  Future<void> onPopInvokedWithResult(bool didPop, Object? result) async {
    if (!didPop) {
      await onPageUnfocused();
      if (mounted) {
        canPopNotifier.value = true;
        await context.maybePop(result);
        canPopNotifier.value = false;
      }
    }
  }

  Future<void> onPageFocussed() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.reverse(from: 1).whenComplete(() {
        widget.onPageFocussed?.call();
      });
    });
  }

  Future<void> onPageUnfocused() async {
    await _controller.forward(from: 0).whenComplete(() {
      widget.onPageUnfocused?.call();
    });
  }

  @override
  void didPopNext() {
    onPageFocussed();
  }

  @override
  void didPushNext() {
    onPageUnfocused();
  }

  @override
  void didPush() {
    onPageFocussed();
  }

  @override
  void didPop() {
    onPageUnfocused();
  }

  @override
  void didUpdateWidget(covariant GamePageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    canPopNotifier.dispose();
    _controller.dispose();
    _observer?.unsubscribe(this);
    GamePageBuilder.routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    final startSlideDirection = widget.startSlideDirection;
    final endSlideDirection = widget.endSlideDirection;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget? child) {
          final value = CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ).value;

          final offset = _resolveOffset(
            value: value,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            startSlideDirection: startSlideDirection,
            endSlideDirection: endSlideDirection,
          );

          return Opacity(
            opacity: 1 - value,
            child: Transform.translate(offset: offset, child: child),
          );
        },
      ),
    );
  }

  Offset _resolveOffset({
    required double value,
    required double screenWidth,
    required double screenHeight,
    required GamePageSlideDirection startSlideDirection,
    required GamePageSlideDirection endSlideDirection,
  }) {
    if (_controller.status == AnimationStatus.forward) {
      return _offsetForDirection(
        direction: endSlideDirection,
        value: value,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
    }

    if (_controller.status == AnimationStatus.reverse) {
      return _offsetForDirection(
        direction: startSlideDirection,
        value: value,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
    }

    return Offset.zero;
  }

  Offset _offsetForDirection({
    required GamePageSlideDirection direction,
    required double value,
    required double screenWidth,
    required double screenHeight,
  }) {
    return switch (direction) {
      GamePageSlideDirection.top => Offset(0, -screenHeight * value),
      GamePageSlideDirection.bottom => Offset(0, screenHeight * value),
      GamePageSlideDirection.left => Offset(-screenWidth * value, 0),
      GamePageSlideDirection.right => Offset(screenWidth * value, 0),
      GamePageSlideDirection.middle => Offset.zero,
    };
  }
}
