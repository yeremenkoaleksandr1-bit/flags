import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/features/layers/money_layer/money_layer.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/screens/continents_picker/views/continent_view.dart';
import 'package:flags/screens/continents_picker/views/fast_mode_timer.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class ContinentsPickerScreen extends ArGetScreen<IContinentsPickerPresenter> {
  const ContinentsPickerScreen({
    super.key,
    required super.presenter,
  }) : super(tag: "single");

  @override
  Widget build(BuildContext context, IContinentsPickerPresenter presenter) {
    final moneyLayer = UiMoneyLayer.find();

    return GameSafeArea(
      child: GameTransitionPageBuilder(
        onPageFocussed: moneyLayer.show,
        onPageUnfocused: moneyLayer.hide,
        startSlideDirection: GamePageSlideDirection.middle,
        endSlideDirection: GamePageSlideDirection.middle,
        child: presenter.obx(
          (state) => SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 250,
                  child: ContinentsSlider(
                    continents: state!.continents,
                    onPressed: presenter.onContinentSelected,
                  ),
                ),
                FastModePlayTimerView(
                  onTapPlayFastMode: presenter.onPlayFastMode,
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
  }
}
