import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_state.dart';
import 'package:flags/main/components/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildAppState extends StatelessWidget {
  const BuildAppState({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, AppState state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocDynamicStateBuilder(
      bloc: context.read<IAppCubit>(),
      loadingBuilder: Splash.new,
      builder: builder,
    );
  }
}
