import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/enums/continent_type.dart';
import 'package:flags/domain/enums/game_difficult.dart';
import 'package:flags/domain/enums/game_mode_type.dart';
import 'package:flags/domain/enums/game_style_type.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/continents_picker/presentation/views/continent_view.dart';
import 'package:flags/features/continents_picker/presentation/views/fast_mode_timer.view.dart';
import 'package:flags/features/games/presentation/games_factory.page.dart';
import 'package:flags/features/levels_picker/presentation/components/level_button.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/prefabs/flags/asia.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/presenters/continents_picker/continents_picker.presenter.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/services/onboarding/onbloarding.controller.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

@RoutePage()
class ContinentsPickerScreen extends StatefulWidget {
  const ContinentsPickerScreen({super.key}) : super();

  @override
  State<ContinentsPickerScreen> createState() => _ContinentsPickerScreenState();
}

class _ContinentsPickerScreenState extends State<ContinentsPickerScreen> {
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  final GlobalKey oContinentButton = GlobalKey();

  final GlobalKey oFastModeButton = GlobalKey();

  final GlobalKey showCaseWidgetKey = GlobalKey();

  late final OnboardingController _onboardingController;

  @override
  void initState() {
    super.initState();
    _onboardingController = OnboardingController(
      tag: "continents_picker4",
      showcaseKey: showCaseWidgetKey,
      widgetsKeys: [oContinentButton, oFastModeButton],
      service: AppScope.readBootstrapOf(context).onboardingService,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final context = showCaseWidgetKey.currentContext;
      if (context == null) {
        return;
      }

      _onboardingController.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IContinentsPickerCubit>();
    final moneyLayer = UiMoneyLayer.find();

    void onContinentPicked(ContinentType type) {
      context.navigateTo(
        LevelsPickerRouter(
          continentType: type,
          gameProcessType: cubit.params.gameProcessType,
        ),
      );
    }

    void onPlayFastMode() {
      final continent = [...ContinentType.values].random();

      final levels = FactoryGameContinent().create(continent);

      context.navigateTo(
        LevelsPickerRouter(
          continentType: continent,
          gameProcessType: cubit.params.gameProcessType,
          children: [
            GamesFactoryRoute(
              params: GamesFactoryPageParams(
                level: levels.levels.random(),
                difficult: [...GameDifficult.values].random(),
                gamesType: GameStyleType.fast,
                gameMode: cubit.params.gameProcessType,
                continentType: continent,
              ),
            ),
          ],
        ),
      );
    }

    void onPageFocussed() {
      audioCubit.playBgm(GameMusics.continents);
      moneyLayer.show();
    }

    void onPageUnfocused() {
      audioCubit.playBgm(GameMusics.main);
      moneyLayer.hide();
    }

    return FShowcaseWidget(
      showcaseKey: showCaseWidgetKey,
      enableShowcase: _onboardingController.canShow,
      onFinish: _onboardingController.complete,
      builder: (BuildContext context) {
        return GameSafeArea(
          child: GamePageBuilder(
            onPageFocussed: onPageFocussed,
            onPageUnfocused: onPageUnfocused,
            startSlideDirection: GamePageSlideDirection.middle,
            endSlideDirection: GamePageSlideDirection.middle,
            child: BlocDynamicStateBuilder(
              bloc: cubit,
              builder: (BuildContext context, ContinentsPickerState state) {
                return SafeArea(
                  child: Stack(
                    children: [
                      // Row(
                      //   children: [
                      //     FGreenButton(
                      //       onPressed: () {
                      //         context.read<GamePreferencesCubit>().addMoney(1);
                      //       },
                      //       child: FText("add money"),
                      //     ),
                      //     FGreenButton(
                      //       onPressed: () {
                      //         context.read<GamePreferencesCubit>().removeMoney(1);
                      //       },
                      //       child: FText("remove money"),
                      //     ),
                      //   ],
                      // ),
                      // FGreenButton(
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         final flag = HongKongFlag();
                      //         return FittedBox(
                      //           fit: BoxFit.fitWidth,
                      //           child: FlagView(flag: flag),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: FText("open"),
                      // ),
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
                              onPressed: onContinentPicked,
                              gameProcessType: cubit.params.gameProcessType,
                            ),
                          ),
                        ),
                      ),
                      FastModePlayTimerView(
                        onTapPlayFastMode: onPlayFastMode,
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
