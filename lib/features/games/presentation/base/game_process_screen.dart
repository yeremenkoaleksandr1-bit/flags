import 'package:flutter/widgets.dart';

abstract class GameProcessScreen<T> extends StatefulWidget {
  const GameProcessScreen({
    super.key,
    required this.cubit,
  });

  final T cubit;

  @override
  State<GameProcessScreen<T>> createState();
}

abstract class GameProcessScreenState<T> extends State<GameProcessScreen<T>>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // AppRouter.routeObserver.subscribe(
    //   this,
    //   ModalRoute.of(context)!,
    // );
  }
}
