import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/features/levels_picker/presentation/components/levels_section.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContinentLevelsView extends StatelessWidget {
  const ContinentLevelsView({
    super.key,
    required this.onSelected,
    required this.sections,
    required this.continent,
  });

  final ContinentType continent;

  final List<GameLevelsSection> sections;

  final void Function(GameLevel level, GameDifficult difficult) onSelected;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: SingleChildScrollView(
        child: Column(
          spacing: 24,
          crossAxisAlignment: .stretch,
          children: [
            ...sections.map(
              (e) => ContinentLevelsSection(
                section: e,
                continent: continent,
                onLevelSelected: (level) => onSelected(level, e.difficulty),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
