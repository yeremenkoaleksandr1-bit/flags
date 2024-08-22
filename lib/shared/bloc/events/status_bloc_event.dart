import 'package:equatable/equatable.dart';

abstract class StatusBlocBaseEvent extends Equatable {
  const StatusBlocBaseEvent();

  @override
  List<Object?> get props => [];
}

class StatusBlocLoadDataEvent extends StatusBlocBaseEvent {}

class StatusBlocRefreshDataEvent extends StatusBlocBaseEvent {}
