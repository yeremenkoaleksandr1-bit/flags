import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/state/levels_page.state.dart';
import 'package:flags/screens/levels_picker/components/continent_title.dart';
import 'package:flags/screens/levels_picker/view/levels_view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class LevelsPickerScreen extends GetScreen<ILevelsPickerPresenter> {
  const LevelsPickerScreen({
    super.key,
    required super.controller,
  }) : super(tag: 'single');

  @override
  Widget build(BuildContext context, ILevelsPickerPresenter controller) {
    return GamePageBuilder(
      curve: Curves.easeInQuad,
      startSlideDirection: GamePageSlideDirection.bottom,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: GameSafeArea(
        child: StateMixinBuilder(
          stateMixin: controller,
          builder: (LevelsPickerState state) {
            return Column(
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
                      controller.onLevelPicked(
                        level,
                        difficult,
                        GameStyleType.common,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
