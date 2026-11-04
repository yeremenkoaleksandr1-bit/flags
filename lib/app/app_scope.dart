import 'package:flags/app/app_bootstrap.dart';
import 'package:flutter/widgets.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.bootstrap,
    required super.child,
  });

  final AppBootstrap bootstrap;

  static AppBootstrap bootstrapOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing in widget tree');
    return scope!.bootstrap;
  }

  static AppBootstrap readBootstrapOf(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();
    final scope = element?.widget as AppScope?;
    assert(scope != null, 'AppScope is missing in widget tree');
    return scope!.bootstrap;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return oldWidget.bootstrap != bootstrap;
  }
}
