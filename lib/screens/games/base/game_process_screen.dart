import 'package:armar/armar.dart';
import 'package:flutter/widgets.dart';

import '../../../presentation/navigator/router.dart';
import '../../../uikit/layout_components/overlayment/overlayment.provider.dart';

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
