import 'package:armar/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum GamePageSlideDirection {
  top,
  bottom,
  left,
  right,
  middle,
}

class GameTransitionPageBuilder extends StatefulWidget {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  const GameTransitionPageBuilder({
    super.key,
    required this.child,
    this.startSlideDirection = GamePageSlideDirection.right,
    this.endSlideDirection = GamePageSlideDirection.left,
    this.curve = Curves.linear,
  });

  final Widget child;

  final GamePageSlideDirection startSlideDirection;
  final GamePageSlideDirection endSlideDirection;

  final Curve curve;

  @override
  State<GameTransitionPageBuilder> createState() =>
      _GameTransitionPageBuilderState();
}

class _GameTransitionPageBuilderState extends State<GameTransitionPageBuilder>
    with RouteAware, TickerProviderStateMixin {
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
    GameTransitionPageBuilder.routeObserver
        .subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _controller.dispose();
    GameTransitionPageBuilder.routeObserver.unsubscribe(this);
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
                      break;
                    case GamePageSlideDirection.bottom:
                      translationY = screenHeight * value;
                      break;
                    case GamePageSlideDirection.left:
                      translationX = -screenWidth * value;
                      break;
                    case GamePageSlideDirection.right:
                      translationX = screenWidth * value;
                      break;
                    case GamePageSlideDirection.middle:
                      translationX = 1;
                      translationY = 1;
                      break;
                  }
                } else if (_controller.status == AnimationStatus.reverse) {
                  switch (startSlideDirection) {
                    case GamePageSlideDirection.top:
                      translationY = -screenHeight * value;
                      break;
                    case GamePageSlideDirection.bottom:
                      translationY = screenHeight * value;
                      break;
                    case GamePageSlideDirection.left:
                      translationX = -screenWidth * value;
                      break;
                    case GamePageSlideDirection.right:
                      translationX = screenWidth * value;
                      break;
                    case GamePageSlideDirection.middle:
                      translationX = 1;
                      translationY = 1;
                      break;
                  }
                } else {
                  translationX = 1;
                  translationY = 1;
                }

                return Transform.translate(
                  offset: Offset(translationX, translationY),
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
  void didPop() {
    _controller.forward(from: 0);
    super.didPop();
  }

  @override
  void didPopNext() {
    _controller.reverse();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    _controller.forward();
    super.didPushNext();
  }
}
