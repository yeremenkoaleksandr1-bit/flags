// ignore_for_file: invalid_use_of_protected_member, strict_raw_type

import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class StateMixinBuilder<T> extends StatefulWidget {
  const StateMixinBuilder({
    super.key,
    required this.stateMixin,
    required this.builder,
    this.onError,
    this.onEmpty,
    this.onLoading,
    this.onCustom,
  });

  final IStateMixin<T> stateMixin;

  final NotifierBuilder<T> builder;
  final Widget Function(String? error)? onError;
  final Widget? onLoading;
  final Widget? onEmpty;
  final WidgetBuilder? onCustom;

  @override
  State<StateMixinBuilder<T>> createState() =>
      _StateMixinBuilderState<T, StateMixinBuilder<T>>();
}

class SliverStateMixinBuilder<T> extends StateMixinBuilder<T> {
  const SliverStateMixinBuilder({
    super.key,
    required super.stateMixin,
    required super.builder,
    super.onError,
    super.onEmpty,
    super.onLoading,
    super.onCustom,
  });

  @override
  State<StateMixinBuilder<T>> createState() =>
      _ArSliverStateMixinBuilderState();
}

class _ArSliverStateMixinBuilderState<T>
    extends _StateMixinBuilderState<T, SliverStateMixinBuilder<T>> {
  @override
  Widget buildLoader(LoadingStatus<T> value) {
    return SliverFillRemaining(
      child: super.buildLoader(value),
    );
  }

  @override
  Widget buildErrorError(ErrorStatus<T, dynamic> value) {
    return SliverFillRemaining(
      child: super.buildErrorError(value),
    );
  }

  @override
  Widget buildEmptyEmpty(EmptyStatus<T> value) {
    return SliverFillRemaining(
      child: super.buildEmptyEmpty(value),
    );
  }

  @override
  Widget buildCustomStatus(CustomStatus<T> value) {
    return SliverFillRemaining(
      child: super.buildCustomStatus(value),
    );
  }
}

class _StateMixinBuilderState<T, G extends StateMixinBuilder<T>>
    extends State<G> {
  StateMixinThemeProvider get theme => StateMixinThemeProvider.of(context);

  Widget buildLoader(LoadingStatus<T> value) {
    return widget.onLoading ??
        theme.loadingBuilder?.call() ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Widget buildErrorError(ErrorStatus<T, dynamic> value) {
    return widget.onError?.call(value.errorMessage) ??
        theme.errorBuilder?.call(value.errorMessage) ??
        Center(
          child: Text(
            'A error occurred: ${value.errorMessage}',
          ),
        );
  }

  Widget buildEmptyEmpty(EmptyStatus<T> value) {
    return widget.onEmpty ?? theme.emptyBuilder?.call() ?? nil;
  }

  Widget buildCustomStatus(CustomStatus<T> value) {
    return widget.onCustom?.call(context) ?? nil;
  }

  Widget buildSuccessStatus(SuccessStatus<T> value) {
    return widget.builder(value.data);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.stateMixin as StateMixin<T>;

    return ValueListenableBuilder(
      valueListenable: state.statusRx,
      builder: (
        BuildContext context,
        GetStatus<T> value,
        Widget? child,
      ) {
        final status = state.statusRx.value;

        return Builder(
          key: ValueKey(status.data.hashCode),
          builder: (context) {
            if (status.isLoading) {
              return buildLoader(
                status as LoadingStatus<T>,
              );
            }

            if (status.isError) {
              return buildErrorError(
                status as ErrorStatus<T, dynamic>,
              );
            }

            if (status.isEmpty) {
              return buildEmptyEmpty(
                status as EmptyStatus<T>,
              );
            }

            if (status.isSuccess) {
              return buildSuccessStatus(
                status as SuccessStatus<T>,
              );
            }

            if (status.isCustom) {
              return buildCustomStatus(
                status as CustomStatus<T>,
              );
            }

            throw UnimplementedError("${status.runtimeType}");
          },
        );
      },
    );
  }
}
