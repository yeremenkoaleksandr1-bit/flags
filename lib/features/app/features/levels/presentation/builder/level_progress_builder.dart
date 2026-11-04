import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LevelProgressBuilder extends StatelessWidget {
  const LevelProgressBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final Widget Function(
    BuildContext context,
      GameModeProgressData state,
  ) builder;

  final bool Function(
      GameModeProgressData previous,
      GameModeProgressData current,
  )? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameLevelsCubit, GameModeProgressData>(
      bloc: context.read<GameLevelsCubit>(),
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
