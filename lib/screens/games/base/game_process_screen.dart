import 'package:armar/armar.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flutter/widgets.dart';

abstract class GameProcessScreen<T> extends ArGetScreen<T> {
  const GameProcessScreen({super.key, required super.presenter});

  @override
  State<ArGetScreen<T>> createState() => GameProcessScreenState();
}

class GameProcessScreenState<T> extends ArGetScreenState<T> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouter.routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }
}
