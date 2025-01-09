import 'package:flags/domain/enums/continent_type.dart';
import 'package:flags/domain/enums/game_mode_type.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/features/app/features/levels/presentation/builder/level_progress_builder.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedLevelsCountStreamBuilder extends StatelessWidget {
  const CompletedLevelsCountStreamBuilder({
    super.key,
    required this.continent,
    required this.gameMode,
    required this.builder,
  });

  final ContinentType continent;
  final GameProcessType gameMode;

  final Widget Function(int quantity) builder;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameLevelsCubit>();

    return LevelProgressBuilder(
      builder: (BuildContext context, GameModeProgressData state) {
        return builder(cubit.getContinentCompletedLevels(continent));
      },
    );
  }
}
