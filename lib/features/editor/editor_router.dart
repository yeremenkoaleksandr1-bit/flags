import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/features/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EditorRouter extends StatelessWidget implements AutoRouteWrapper {
  const EditorRouter({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => MyFlagsCubit(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
