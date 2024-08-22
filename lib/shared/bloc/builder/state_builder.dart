import 'package:flags/shared/animations/slide_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/state_builder_theme.dart';
import '../state/status_bloc_state.dart';
import '../stated_cubit.dart';

class BlocStateBuilder<T> extends StatelessWidget {
  final StatedCubit<T> listener;
  final Widget Function()? loadingBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function(ErrorState<dynamic> e)? errorBuilder;
  final Widget Function(T state) builder;
  final Duration animationDuration;
  final Widget Function(Widget child, Animation<double> animation)?
      transitionBuilder;

  final bool Function(DynamicState<T>, DynamicState<T>)? buildWhen;

  const BlocStateBuilder({
    super.key,
    required this.listener,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.animationDuration = const Duration(milliseconds: 300),
    this.transitionBuilder,
    this.buildWhen,
  });

  factory BlocStateBuilder.invisible(
      {required StatedCubit<T> listener,
      required Widget Function(T state) builder,
      Widget Function()? loadingBuilder,
      Widget Function()? emptyBuilder,
      Widget Function(ErrorState<dynamic> e)? errorBuilder,
      Duration animationDuration = const Duration(milliseconds: 300),
      Widget Function(Widget child, Animation<double> animation)?
          transitionBuilder,
      bool Function(DynamicState<T>, DynamicState<T>)? buildWhen}) {
    return BlocStateBuilder(
      listener: listener,
      builder: builder,
      buildWhen: buildWhen,
      loadingBuilder: loadingBuilder ?? () => const SizedBox.shrink(),
      emptyBuilder: emptyBuilder ?? () => const SizedBox.shrink(),
      errorBuilder: errorBuilder ?? (_) => const SizedBox.shrink(),
      animationDuration: animationDuration,
      transitionBuilder: transitionBuilder ?? (child, animation) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatedCubit<T>, DynamicState<T>>(
      bloc: listener,
      buildWhen: buildWhen ?? (o, n) => o.runtimeType != n.runtimeType,
      builder: (BuildContext context, state) {
        Widget content;

        if (state is LoadingState) {
          content = loadingBuilder?.call() ??
              BlocStateBuilderThemeProvider.of(context)?.buildLoader?.call() ??
              const Center(
                child: CircularProgressIndicator(),
              );
        } else if (state is SuccessState<T>) {
          content = builder(state.data);
        } else if (state is ErrorState) {
          final errorState = state as ErrorState;
          content = errorBuilder?.call(errorState) ??
              Text(
                'Error: ${errorState.error}',
              );
        } else if (state is EmptyState) {
          content = emptyBuilder?.call() ?? const Text('No data available');
        } else {
          content = const SizedBox.shrink();
        }

        return AnimatedSwitcher(
          duration: animationDuration,
          transitionBuilder: transitionBuilder ?? slideTransitionBuilder,
          child: content,
        );
      },
    );
  }
}
