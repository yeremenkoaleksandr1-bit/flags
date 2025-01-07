import 'package:auto_route/auto_route.dart';
import 'package:flags/navigator/game_navigation_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum GamePageSlideDirection {
  top,
  bottom,
  left,
  right,
  middle,
}

class GamePageBuilder extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const GamePageBuilder({
    super.key,
    required this.child,
    this.startSlideDirection = GamePageSlideDirection.right,
    this.endSlideDirection = GamePageSlideDirection.left,
    this.curve = Curves.linear,
    this.onPageFocussed,
    this.onPageUnfocused,
  });

  final Widget child;

  final GamePageSlideDirection startSlideDirection;
  final GamePageSlideDirection endSlideDirection;

  final Curve curve;

  final VoidCallback? onPageFocussed;
  final VoidCallback? onPageUnfocused;

  @override
  State<GamePageBuilder> createState() => _GamePageBuilderState();
}

class _GamePageBuilderState extends State<GamePageBuilder>
    with AutoRouteAware, SingleTickerProviderStateMixin
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
      duration: const Duration(milliseconds: 500),
    );

    _controller.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer =
        RouterScope.of(context).firstObserverOfType<GameAutoRouteObserver>();

    if (_observer != null) {
      _observer!.subscribe(this, context.routeData);
    }

    final ModalRoute<dynamic>? nextRoute = ModalRoute.of(context);
    if (nextRoute != _route) {
      _route?.unregisterPopEntry(this);
      _route = nextRoute;
      _route?.registerPopEntry(this);
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
    await _controller.reverse(from: 1).whenComplete(() {
      widget.onPageFocussed?.call();
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
  }

  @override
  Widget build(BuildContext context) {
    final startSlideDirection = widget.startSlideDirection;
    final endSlideDirection = widget.endSlideDirection;
    double translationX = 0;
    double translationY = 0;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenSize = constraints.biggest;
        final screenWidth = screenSize.width;
        final screenHeight = screenSize.height;

        return widget.child.animate(
          autoPlay: false,
          controller: _controller,
          effects: [
            FadeEffect(
              begin: 1,
              end: 0,
              curve: widget.curve,
            ),
            CustomEffect(
              curve: widget.curve,
              builder: (
                BuildContext context,
                double value,
                Widget child,
              ) {
                if (_controller.status == AnimationStatus.forward) {
                  switch (endSlideDirection) {
                    case GamePageSlideDirection.top:
                      translationY = -screenHeight * value;
                    case GamePageSlideDirection.bottom:
                      translationY = screenHeight * value;
                    case GamePageSlideDirection.left:
                      translationX = -screenWidth * value;
                    case GamePageSlideDirection.right:
                      translationX = screenWidth * value;
                    case GamePageSlideDirection.middle:
                      translationX = 1;
                      translationY = 1;
                  }
                } else if (_controller.status == AnimationStatus.reverse) {
                  switch (startSlideDirection) {
                    case GamePageSlideDirection.top:
                      translationY = -screenHeight * value;
                    case GamePageSlideDirection.bottom:
                      translationY = screenHeight * value;
                    case GamePageSlideDirection.left:
                      translationX = -screenWidth * value;
                    case GamePageSlideDirection.right:
                      translationX = screenWidth * value;
                    case GamePageSlideDirection.middle:
                      translationX = 1;
                      translationY = 1;
                  }
                } else {
                  translationX = 1;
                  translationY = 1;
                }

                return Transform.translate(
                  offset: Offset(
                    translationX - 1,
                    translationY - 1,
                  ),
                  child: child,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
