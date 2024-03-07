import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/ui/builders/app/components/splash.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../presentation/app/state/app.state.dart';
import '../../../uikit/theme/theme.dart';
import '../../ui.dart';
import '../main_view_builder.dart';

class AppScreen extends ArGetScreen<IAppPresenter> {
  AppScreen({
    super.key,
  }) : super(
          tag: "app",
          presenter: (context) => AppPresenterImpl(context: context),
        );

  @override
  Widget build(BuildContext context, IAppPresenter presenter) {
    return MainViewBuilder(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        ),
        child: FastValueBuilder(
          listen: presenter.statusRx,
          builder: (GetStatus<IAppState> value) {
            if (value.data is AppState) {
              return AppRouterBuilder(
                router: presenter.router,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
