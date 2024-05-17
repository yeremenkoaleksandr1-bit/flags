import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/features/vibration/vibration.provider.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/app/state/app.state.dart';
import 'package:flags/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class AppScreen extends GetScreen<IAppPresenter> {
  AppScreen({
    super.key,
  }) : super(
          tag: "app",
          controller: (context) => AppPresenterImpl(context: context),
        );

  @override
  Widget build(BuildContext context, IAppPresenter controller) {
    return MainViewBuilder(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: controller.statusRx,
          builder: (
            BuildContext context,
            GetStatus<IAppState> value,
            Widget? child,
          ) {
            if (value.data is AppState) {
              return PhoneVibrationProvider(
                child: AudioProvider(
                  child: ShopProvider(
                    child: Stack(
                      children: [
                        AppRouterBuilder(
                          router: controller.router,
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
