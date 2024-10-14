import 'package:equatable/equatable.dart';

sealed class DynamicState<T> extends Equatable {
  const DynamicState();

  R? when<R>({
    R Function()? loading,
    R Function(SuccessState<T> state)? success,
    R Function(dynamic error)? error,
    R Function()? empty,
  }) {
    if (this is LoadingState<T>) {
      return loading?.call();
    } else if (this is SuccessState<T>) {
      return success?.call(this as SuccessState<T>);
    } else if (this is ErrorState<T>) {
      return error?.call((this as ErrorState<T>).error);
    } else if (this is EmptyState<T>) {
      return empty?.call();
    }
    return null;
  }

  @override
  List<Object?> get props => [];
}

final class LoadingState<T> extends DynamicState<T> {
  const LoadingState();
}

final class SuccessState<T> extends DynamicState<T> {
  final T data;

  const SuccessState(this.data);

  @override
  List<Object?> get props => [data];

  SuccessState<T> copyWith({
    T? data,
  }) {
    return SuccessState(
      data ?? this.data,
    );
  }
}

final class ErrorState<T> extends DynamicState<T> {
  final dynamic error;

  const ErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

final class EmptyState<T> extends DynamicState<T> {
  const EmptyState();
}
