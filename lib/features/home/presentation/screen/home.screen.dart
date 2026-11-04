import 'package:auto_route/auto_route.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/debug/presentation/debug_button.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/services/onboarding/onbloarding.controller.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/banners/remove_ads_banner.dart';
import 'package:flags/uikit/components/buttons/actions/sound_mute.button.dart';
import 'package:flags/uikit/components/buttons/actions/vibration_mute.button.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  final GlobalKey oPlayButton = GlobalKey();

  final GlobalKey oMyFlagsButton = GlobalKey();

  final GlobalKey showCaseWidgetKey = GlobalKey();

  late final OnboardingController _onboardingController;

  void openGamePickerPage() {
    context.navigateTo(const GameModePickerRoute());
    // QR.toName(Routes.gameModePicker);
  }

  void openMyFlagsPage() {
    context.navigateTo(const MyFlagsRoute());
    //  QR.toName(Routes.myFlagsGallery);
  }

  @override
  void initState() {
    super.initState();
    _onboardingController = OnboardingController(
      tag: "home",
      showcaseKey: showCaseWidgetKey,
      widgetsKeys: [oPlayButton, oMyFlagsButton],
      service: AppScope.readBootstrapOf(context).onboardingService,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (showCaseWidgetKey.currentContext != null) {
        _onboardingController.show(showCaseWidgetKey.currentContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = context.read<IAppCubit>();

    void onPageFocussed() {
      audioCubit.playBgm(GameMusics.main);
    }

    return FShowcaseWidget(
      showcaseKey: showCaseWidgetKey,
      enableShowcase: _onboardingController.canShow,
      onFinish: _onboardingController.complete,
      builder: (BuildContext context) {
        return GameSafeArea(
          child: GamePageBuilder(
            startSlideDirection: GamePageSlideDirection.middle,
            endSlideDirection: GamePageSlideDirection.middle,
            onPageFocussed: onPageFocussed,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    // без пружины: если меню помещается на экран, оно не
                    // двигается; прокрутка — только если кнопки не влезли
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: ThemePaddings.screen,
                        sliver: SliverList.list(
                          children: [
                            // обычная картинка вместо SpriteUIWidget: тот на
                            // телефонах (Impeller) рисовал тонкую линию под логотипом
                            Image.asset(
                              Assets.images.logo.path,
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.medium,
                            ),
                            Gap.v32,
                            FYellowButton(
                              onPressed: openGamePickerPage,
                              child: Center(child: FText("PLAY")),
                            ),
                            Gap.v12,
                            FYellowButton(
                              onPressed: openMyFlagsPage,
                              child: Center(child: FText("MY FLAGS")),
                            ),
                          ],
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: ThemePaddings.screen,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (appCubit.preferences.isDebugMode) ...[
                                const DebugButton(),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FVibrationMuteButton(),
                                  Gap.h12,
                                  const FSoundMuteButton(),
                                ],
                              ),
                              Gap.v24,
                              const RemoveAdsBanner(),
                              Gap.v24,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
