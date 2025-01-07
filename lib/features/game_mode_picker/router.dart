import 'package:auto_route/auto_route.dart';
import 'package:flags/presentation/presenters/game_mode_picker/game_mode_picker.presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class GameModePickerRouter extends StatelessWidget implements AutoRouteWrapper {
  const GameModePickerRouter({
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<IGameModePickerCubit>(
      create: (context) => GameModePickerCubitImpl(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
