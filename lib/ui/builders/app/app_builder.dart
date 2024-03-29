import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flutter/material.dart';

import '../../../features/layers/layer.view.dart';
import '../../../features/layers/money_layer/money_layer.dart';
import '../../../presentation/app/state/app.state.dart';
import '../../ui.dart';

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
              return ShopProvider(
                child: Stack(
                  children: [
                    AppRouterBuilder(
                      router: presenter.router,
                    ),
                    const UiMoneyLayer(),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
