import 'package:flags/core/flutter_engine.dart';
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
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

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
    with RouteAware, SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller.value = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reverse(from: 1);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      GamePageBuilder.routeObserver.subscribe(this, route);
    }

    if (route!.isCurrent) {
      FlutterEngine.widgetPostFrameCallback((timeStamp) {
        _controller.reverse(from: 1).whenCompleteOrCancel(() {
          widget.onPageFocussed?.call();
        });
      });
    } else {
      widget.onPageFocussed?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    GamePageBuilder.routeObserver.unsubscribe(this);
    super.dispose();
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

  @override
  Future<void> didPop() async {
    await _controller.forward(from: 0).whenComplete(() {
      widget.onPageUnfocused?.call();
    });
    super.didPop();
  }

  @override
  Future<void> didPopNext() async {
    FlutterEngine.widgetPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration());
      await _controller.reverse(from: 1);
      super.didPopNext();
    });
  }

  @override
  void didPushNext() {
    FlutterEngine.widgetPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration());
      _controller.forward(from: 0);
      widget.onPageUnfocused?.call();
    });

    super.didPushNext();
  }
}
