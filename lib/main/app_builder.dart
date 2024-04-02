import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/audio/audio.service.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/app/state/app.state.dart';
import 'package:flags/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../features/vibration/vibration.provider.dart';

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
              return PhoneVibrationProvider(
                child: AudioProvider(
                  child: ShopProvider(
                    child: Stack(
                      children: [
                        AppRouterBuilder(
                          router: presenter.router,
                        ),
                        const UiMoneyLayer(),
                      ],
                    ),
                  ),
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
