import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/levels_picker/presentation/components/levels_section.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/widgets.dart';

class ContinentLevelsView extends StatelessWidget {
  const ContinentLevelsView({
    super.key,
    required this.onSelected,
    required this.sections,
  });

  final List<GameLevelsSection> sections;

  final void Function(GameLevel level, GameDifficult difficult) onSelected;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: SingleChildScrollView(
        child: ColumnSuper(
          innerDistance: 24,
          children: [
            ...sections.map(
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
