import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/continents_picker/presentation/views/continent_view.dart';
import 'package:flags/features/continents_picker/presentation/views/fast_mode_timer.view.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/services/onboarding/onbloarding.controller.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

@RoutePage()
class ContinentsPickerScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const ContinentsPickerScreen({
    super.key,
    required this.params,
  }) : super();

  final ContinentPickerRouteParams params;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<IContinentsPickerCubit>(
      create: (BuildContext context) {
        return ContinentsPickerCubitImpl(
          routeParams: params,
        );
      },
      child: this,
    );
  }

  @override
  State<ContinentsPickerScreen> createState() => _ContinentsPickerScreenState();
}

class _ContinentsPickerScreenState extends State<ContinentsPickerScreen> {
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

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
  void initState() {
    super.initState();
    audioCubit.playBgm(GameMusics.continents);

    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _onboardingController.show(showCaseWidgetKey.currentContext!);
      });
    } catch (e) {}
  }

  @override
  @override
  void onClose() {
    // final audio = AudioProvider.of();
    //
    // audio.playBgm(GameMusics.main);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IContinentsPickerCubit>();
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
            child: BlocStateBuilder(
              listener: cubit,
              builder: (ContinentsPickerState state) {
                return SafeArea(
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
                              continents: state.continents,
                              onPressed: cubit.onContinentSelected,
                              gameProcessType: widget.params.gameProcessType,
                            ),
                          ),
                        ),
                      ),
                      FastModePlayTimerView(
                        onTapPlayFastMode: cubit.onPlayFastMode,
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
