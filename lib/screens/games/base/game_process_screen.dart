import 'package:state_manager/state_manager.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flutter/widgets.dart';

abstract class GameProcessScreen<T> extends GetScreen<T> {
  const GameProcessScreen({super.key, required super.controller});

  @override
  State<GetScreen<T>> createState() => GameProcessScreenState();
}

class GameProcessScreenState<T> extends GetScreenState<T> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouter.routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }
}
