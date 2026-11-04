import 'package:auto_route/auto_route.dart';
import 'package:flags/domain/enums/continent_type.dart';
import 'package:flags/domain/enums/game_mode_type.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/navigator/game_navigation_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LevelsPickerRouter extends StatelessWidget implements AutoRouteWrapper {
  const LevelsPickerRouter({
    super.key,
    required this.continentType,
    required this.gameProcessType,
  });

  final ContinentType continentType;
  final GameProcessType gameProcessType;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ILevelsPickerCubit>(
      create: (context) => LevelsPickerCubitImpl(
        continentType: continentType,
        gameProcessType: gameProcessType,
        levelsCubit: context.read<GameLevelsCubit>(),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      navigatorObservers: () => [GameAutoRouteObserver()],
    );
  }
}
