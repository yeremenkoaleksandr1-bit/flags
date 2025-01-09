import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/navigator/router.gr.dart';

import 'package:flags/services/onboarding/onbloarding.controller.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/buttons/actions/sound_mute.button.dart';
import 'package:flags/uikit/components/buttons/actions/vibration_mute.button.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  final GlobalKey oPlayButton = GlobalKey();

  final GlobalKey oMyFlagsButton = GlobalKey();

  final GlobalKey showCaseWidgetKey = GlobalKey();

  late final OnboardingController _onboardingController = OnboardingController(
    tag: "home",
    widgetsKeys: [
      oPlayButton,
      oMyFlagsButton,
    ],
  );

  void openGamePickerPage() {
    context.navigateTo(
      const GameModePickerRoute(),
    );
    // QR.toName(Routes.gameModePicker);
  }

  void openMyFlagsPage() {
    context.navigateTo(
      const MyFlagsRoute(),
    );
    //  QR.toName(Routes.myFlagsGallery);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (showCaseWidgetKey.currentContext != null) {
        _onboardingController.show(showCaseWidgetKey.currentContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    void onPageFocussed(){
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SpriteUIWidget(image: Assets.images.logo.image),
                      const Spacer(),
                      FShowcase(
                        showcaseKey: oPlayButton,
                        tooltip: (bounds) => Positioned(
                          bottom: bounds.top,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FText(
                              "Let's start assembling \nthese frags",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        child: FYellowButton(
                          onPressed: openGamePickerPage,
                          child: Center(
                            child: FText("PLAY"),
                          ),
                        ),
                      ),
                      Gap.v12,
                      FShowcase(
                        showcaseKey: oMyFlagsButton,
                        tooltip: (bounds) => Positioned(
                          top: bounds.top - 112,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FText(
                              "You can also create \nyour own unique flags.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        child: FYellowButton(
                          onPressed: openMyFlagsPage,
                          child: Center(
                            child: FText("MY FLAGS"),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FVibrationMuteButton(),
                          Gap.h12,
                          FSoundMuteButton(),
                        ],
                      ),
                      Gap.v24,
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
