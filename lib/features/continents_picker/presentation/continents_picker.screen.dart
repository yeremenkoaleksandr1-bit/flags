import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/features/continents_picker/presentation/views/continent_view.dart';
import 'package:flags/features/continents_picker/presentation/views/strick_view.dart';
import 'package:flags/features/games/presentation/games_factory.page.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/presenters/continents_picker/continents_picker.presenter.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/services/onboarding/onbloarding.controller.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ContinentsPickerScreen extends StatefulWidget {
  const ContinentsPickerScreen({super.key});

  @override
  State<ContinentsPickerScreen> createState() => _ContinentsPickerScreenState();
}

class _ContinentsPickerScreenState extends State<ContinentsPickerScreen> {
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  IShopCubit get shopCubit => context.read<IShopCubit>();

  final GlobalKey oContinentButton = GlobalKey();
  final GlobalKey oFastModeButton = GlobalKey();
  final GlobalKey showCaseWidgetKey = GlobalKey();

  late final OnboardingController _onboardingController;
  ContinentType? _selectedContinent;

  @override
  void initState() {
    super.initState();
    _onboardingController = OnboardingController(
      tag: 'continents_picker4',
      showcaseKey: showCaseWidgetKey,
      widgetsKeys: [oContinentButton, oFastModeButton],
      service: AppScope.readBootstrapOf(context).onboardingService,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      builder: (context) {
        return GameSafeArea(
          child: GamePageBuilder(
            onPageFocussed: onPageFocussed,
            onPageUnfocused: onPageUnfocused,
            startSlideDirection: GamePageSlideDirection.middle,
            endSlideDirection: GamePageSlideDirection.middle,
            child: BlocDynamicStateBuilder(
              bloc: cubit,
              builder: (context, ContinentsPickerState state) {
                final continents = state.continents;
                if (continents.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selectedContinent =
                    continents.contains(_selectedContinent)
                    ? _selectedContinent!
                    : continents.first;

                if (_selectedContinent != selectedContinent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _selectedContinent = selectedContinent;
                    });
                  });
                }

                return SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
                        child: Column(
                          children: [
                            Gap.v48,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .stretch,
                                children: [
                                  Expanded(
                                    child: FShowcase(
                                      showcaseKey: oContinentButton,
                                      targetPadding: Pad(all: -12.r),
                                      targetShapeBorder: const CircleBorder(),
                                      tooltip: (bounds) => Positioned(
                                        top: bounds.top - 14.h,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: FText(
                                            'Swipe or tap a continent\nto unlock and play',
                                            textAlign: TextAlign.center,
                                            textStyle: const TextStyle(
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: ContinentsSlider(
                                        continents: continents,
                                        gameProcessType:
                                            cubit.params.gameProcessType,
                                        onPressed: onContinentPicked,
                                        onChanged: (continent) {
                                          if (_selectedContinent == continent) {
                                            return;
                                          }
                                          setState(() {
                                            _selectedContinent = continent;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildPlayButton(
                              continents,
                              selectedContinent,
                              onContinentPicked,
                            ),
                            SizedBox(height: 24.h),
                            FShowcase(
                              showcaseKey: oFastModeButton,
                              targetPadding: Pad(
                                horizontal: -8.w,
                                vertical: -6.h,
                              ),
                              tooltip: (bounds) => Positioned(
                                top: bounds.top - 128.h,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: FText(
                                    'Fast mode picks a random continent\nfor a harder run',
                                    textAlign: TextAlign.center,
                                    textStyle: const TextStyle(height: 1),
                                  ),
                                ),
                              ),
                              child: _FastModeCard(onPressed: onPlayFastMode),
                            ),
                            SizedBox(height: 14.h),
                            const FBackButton(),
                          ],
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

  BlocBuilder<IShopCubit, ShopState> buildPlayButton(
    List<ContinentType> continents,
    ContinentType selectedContinent,
    void Function(ContinentType type) onContinentPicked,
  ) {
    return BlocBuilder<IShopCubit, ShopState>(
      builder: (context, _) {
        final selectedIndex = continents.indexOf(
          selectedContinent,
        );
        final selectedTag = 'continent_$selectedIndex';
        final isBought =
            shopCubit.isBought(selectedTag) ||
            shopCubit.getPrice(selectedTag) == -1;

        return _PlayButton(
          continent: selectedContinent,
          isBought: isBought,
          onPressed: isBought
              ? () => onContinentPicked(
                  selectedContinent,
                )
              : null,
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.continent,
    required this.isBought,
    required this.onPressed,
  });

  final ContinentType continent;
  final bool isBought;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FButton(
      color: isBought ? ThemePalette.greenButton : ThemePalette.gray,
      onPressed: onPressed ?? () {},
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBought ? Icons.play_arrow_rounded : Icons.lock_rounded,
                size: 42.sp,
                color: ThemePalette.white,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: FText(
                    isBought
                        ? 'PLAY ${createContinentTitle(continent).toUpperCase()}'
                        : 'UNLOCK ${createContinentTitle(continent).toUpperCase()}',
                    textStyle: TextStyle(
                      fontSize: 28.sp,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FastModeCard extends StatelessWidget {
  const _FastModeCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FButton(
      color: const Color(0xFFDCEEFF),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
        child: Row(
          children: [
            SizedBox(
              width: 56.w,
              height: 56.h,
              child: SpriteUIWidget(
                image: Assets.images.timer.image,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FText(
                    'FAST MODE',
                    textColor: const Color(0xFF154A8D),
                    strokeColor: ThemePalette.white,
                    strokeWidth: 2,
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      FText(
                        'BEST:',
                        textColor: const Color(0xFF154A8D),
                        strokeColor: ThemePalette.white,
                        strokeWidth: 2,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SizedBox.square(
                        dimension: 24.r,
                        child: SpriteUIWidget(
                          image: Assets.images.winnerCup.image,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const WinnerStreakView(),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 40.sp,
              color: const Color(0xFF1F5FAF),
            ),
          ],
        ),
      ),
    );
  }
}
