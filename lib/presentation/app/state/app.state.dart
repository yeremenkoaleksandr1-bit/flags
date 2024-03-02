import 'package:flags/resources/resources.dart';

abstract interface class IAppState {}

class InitializingAppState implements IAppState {}

class AppState implements IAppState {
  final Resources resources;

  AppState({
    required this.resources,
  });
}
