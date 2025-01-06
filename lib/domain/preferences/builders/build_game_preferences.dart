import 'package:flags/domain/domain.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildGamePreferences extends StatelessWidget {
  const BuildGamePreferences({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final Widget Function(
    BuildContext context,
    GamePreferencesState state,
  ) builder;

  final bool Function(
    GamePreferencesState previous,
    GamePreferencesState current,
  )? buildWhen;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GamePreferences>();

    return BlocBuilder<GamePreferences, GamePreferencesState>(
      bloc: cubit,
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
