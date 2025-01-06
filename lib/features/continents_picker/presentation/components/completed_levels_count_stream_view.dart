import 'package:flags/domain/enums/continent_type.dart';
import 'package:flags/domain/enums/game_mode_type.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedLevelsCountStreamBuilder extends StatefulWidget {
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
  State<CompletedLevelsCountStreamBuilder> createState() =>
      _CompletedLevelsCountStreamBuilderState();
}

class _CompletedLevelsCountStreamBuilderState
    extends State<CompletedLevelsCountStreamBuilder> {
  ILevelsService get levelsService => context.read<IAppCubit>().levelsService;



  @override
  Widget build(BuildContext context) {
    return Text("TODO: implement levels count");

  }
}
