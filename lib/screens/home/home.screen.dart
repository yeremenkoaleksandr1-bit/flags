import 'package:state_manager/state_manager.dart';
import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flags/features/onboarding/onbloarding.controller.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presentation.dart';
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
import 'package:qlevar_router/qlevar_router.dart';

class HomeScreen extends GetScreen<IHomePresenter> {
  HomeScreen({
    super.key,
    required super.controller,
  }) : super(tag: "single");

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
    QR.toName(Routes.gameModePicker);
  }

  void openMyFlagsPage() {
    QR.toName(Routes.myFlags);
  }

  @override
  void onReady(BuildContext context) {
    _onboardingController.show(showCaseWidgetKey.currentContext!);
  }

  @override
  void onPreInit(BuildContext context) {
    final audio = AudioProvider.of(context);

    audio.playBgm(GameMusics.main);
  }

  @override
  Widget build(BuildContext context, IHomePresenter presenter) {
    return FShowcaseWidget(
      showcaseKey: showCaseWidgetKey,
      enableShowcase: _onboardingController.canShow,
      onFinish: _onboardingController.complete,
      builder: (BuildContext context) {
        return GameSafeArea(
          child: GamePageBuilder(
            startSlideDirection: GamePageSlideDirection.middle,
            endSlideDirection: GamePageSlideDirection.middle,
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
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Debug mode"),
                      StreamBuilder(
                        stream: IAppPresenter.I.appPreferences.box.watch(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          return Switch(
                            activeTrackColor: ThemePalette.red,
                            trackOutlineColor:
                                MaterialStateProperty.all(Colors.transparent),
                            value:
                                IAppPresenter.I.appPreferences.data.isDebugMode,
                            onChanged: (value) {
                              IAppPresenter.I.appPreferences
                                  .setDebugMode(value);
                            },
                          );
                        },
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
