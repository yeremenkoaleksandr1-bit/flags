import 'package:auto_route/auto_route.dart';
import 'package:flags/navigator/game_navigation_observer.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/features/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EditorRouter extends StatelessWidget implements AutoRouteWrapper {
  const EditorRouter({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final sharedPreferences = AppScope.bootstrapOf(context).sharedPreferences;

    return BlocProvider(
      create: (_) => MyFlagsCubit(
        sharedPreferences: sharedPreferences,
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
