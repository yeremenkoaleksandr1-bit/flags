import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/ui/builders/app/components/splash.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../presentation/app/state/app.state.dart';
import '../main_view_builder.dart';

class AppScreen extends ArGetScreen<IAppPresenter> {
  const AppScreen({
    required this.router,
    required super.presenter,
    super.key,
  }) : super(
          tag: "app",
        );

  final QRouter router;

  @override
  Widget build(BuildContext context, IAppPresenter presenter) {
    return FastValueBuilder(
      listen: presenter.statusRx,
      builder: (GetStatus<IAppState> value) {
        if (value.data is AppState) {
          return MainViewBuilder(
            child: router,
          );
        }

        return const Splash();
      },
    );
  }
}
