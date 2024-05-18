import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/features/onboarding/onbloarding.controller.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/screens/continents_picker/views/continent_view.dart';
import 'package:flags/screens/continents_picker/views/fast_mode_timer.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:state_manager/state_manager.dart';

class ContinentsPickerScreen extends GetScreen<IContinentsPickerPresenter> {
  ContinentsPickerScreen({
    super.key,
    required super.controller,
  }) : super(tag: "single");

  final GlobalKey oContinentButton = GlobalKey();
  final GlobalKey oFastModeButton = GlobalKey();

  final GlobalKey showCaseWidgetKey = GlobalKey();

  late final OnboardingController _onboardingController = OnboardingController(
    tag: "continents_picker4",
    widgetsKeys: [
      oContinentButton,
      oFastModeButton,
    ],
  );

  @override
  void onPreInit(BuildContext context) {
    final audio = AudioProvider.of(context);

    audio.playBgm(GameMusics.continents);
  }

  @override
  void onClose() {
    final audio = AudioProvider.of(QR.context!);

    audio.playBgm(GameMusics.main);
  }

  @override
  void onReady(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onboardingController.show(showCaseWidgetKey.currentContext!);
    });
  }

  @override
  Widget build(BuildContext context, IContinentsPickerPresenter controller) {
    final moneyLayer = UiMoneyLayer.find();

    return FShowcaseWidget(
      showcaseKey: showCaseWidgetKey,
      enableShowcase: _onboardingController.canShow,
      onFinish: _onboardingController.complete,
      builder: (BuildContext context) {
        return GameSafeArea(
          child: GamePageBuilder(
            onPageFocussed: moneyLayer.show,
            onPageUnfocused: moneyLayer.hide,
            startSlideDirection: GamePageSlideDirection.middle,
            endSlideDirection: GamePageSlideDirection.middle,
            child: controller.obx(
              (state) => SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 250,
                      child: Center(
                        child: FShowcase(
                          showcaseKey: oContinentButton,
                          targetPadding: const Pad(all: -12),
                          tooltipPosition: TooltipPosition.bottom,
                          targetShapeBorder: const CircleBorder(),
                          tooltip: (bounds) => Positioned(
                            top: bounds.top - 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: FText(
                                'Complete flags\nand earn money',
                                textAlign: TextAlign.center,
                                textStyle: const TextStyle(height: 1),
                              ),
                            ),
                          ),
                          child: ContinentsSlider(
                            continents: state!.continents,
                            onPressed: controller.onContinentSelected,
                          ),
                        ),
                      ),
                    ),
                    FastModePlayTimerView(
                      onTapPlayFastMode: controller.onPlayFastMode,
                      showcaseKey: oFastModeButton,
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: Pad(bottom: ThemeIndents.s12),
                        child: FBackButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
