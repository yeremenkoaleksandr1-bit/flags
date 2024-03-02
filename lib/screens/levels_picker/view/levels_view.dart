import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/widgets.dart';

import '../components/levels_section.dart';

class ContinentLevelsView extends ArGetLocatorWidget<ILevelsPickerPresenter> {
  const ContinentLevelsView({
    super.key,
    required this.onSelected,
  });

  final void Function(GameLevel level, GameDifficult difficult) onSelected;

  @override
  Widget build(BuildContext context, ILevelsPickerPresenter presenter) {
    return FCard(
      child: SingleChildScrollView(
        child: ColumnSuper(
          innerDistance: 24,
          children: [
            ...presenter.state.levels.sections.map(
              (e) => ContinentLevelsSection(
                section: e,
                onLevelSelected: (level) => onSelected(level, e.difficulty),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
