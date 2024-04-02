import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/screens/levels_picker/components/continent_title.dart';
import 'package:flags/screens/levels_picker/view/levels_view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class LevelsPickerScreen extends ArGetScreen<ILevelsPickerPresenter> {
  const LevelsPickerScreen({super.key, required super.presenter})
      : super(tag: 'single');

  @override
  Widget build(BuildContext context, ILevelsPickerPresenter presenter) {
    return GamePageBuilder(
      curve: Curves.easeInQuad,
      startSlideDirection: GamePageSlideDirection.bottom,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: GameSafeArea(
        child: presenter.obx(
          (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: Pad(horizontal: 8),
                child: Row(
                  children: [
                    FBackButton(),
                    Gap.h24,
                    Expanded(
                      child: ContinentTitleView(),
                    ),
                    Gap.h24,
                  ],
                ),
              ),
              Expanded(
                child: ContinentLevelsView(
                  onSelected: (GameLevel level, GameDifficult difficult) {
                    presenter.onLevelPicked(
                      level,
                      difficult,
                      GameStyleType.common,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
