import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

import '../../presentation/presentation.dart';
import '../../ui/game_scaffold.dart';
import '../../uikit/components/buttons/buttons.dart';
import 'views/continent_view.dart';
import 'views/fast_mode_timer.view.dart';

class ContinentsPickerScreen extends ArGetScreen<IContinentsPickerPresenter> {
  const ContinentsPickerScreen({
    super.key,
    required super.presenter,
  }) : super(tag: "single");

  @override
  Widget build(BuildContext context, IContinentsPickerPresenter presenter) {
    return GameTransitionPageBuilder(
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
              const FastModePlayTimerView(),
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
    );
  }
}
