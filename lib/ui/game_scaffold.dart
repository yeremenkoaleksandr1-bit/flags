import 'package:flutter/material.dart';

class GameScaffold extends StatefulWidget {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  const GameScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold>
    with RouteAware, TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => Opacity(
        opacity: 1 - _controller.value,
        child: child!,
      ),
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller.value = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reverse();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GameScaffold.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _controller.dispose();
    GameScaffold.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    _controller.reverse();
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
