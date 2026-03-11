import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/presentation/presenters/continents_picker/continents_picker.presenter.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ContinentsPickerRouter extends StatelessWidget
    implements AutoRouteWrapper {
  const ContinentsPickerRouter({
    super.key,
    required this.params,
  });

  final ContinentPickerRouteParams params;

  @override
  Widget wrappedRoute(BuildContext context) {
    final sharedPreferences = AppScope.bootstrapOf(context).sharedPreferences;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameLevelsCubit(
            sharedPreferences,
            gameMode: params.gameProcessType,
          ),
        ),
        BlocProvider<IContinentsPickerCubit>(
          create: (BuildContext context) {
            return ContinentsPickerCubitImpl(
              params: params,
            );
          },
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
