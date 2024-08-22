import 'package:equatable/equatable.dart';

sealed class DynamicState<T> extends Equatable {
  const DynamicState();

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
