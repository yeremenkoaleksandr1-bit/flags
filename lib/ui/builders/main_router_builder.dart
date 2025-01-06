import 'package:auto_route/auto_route.dart';
import 'package:flags/logger.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class AppRouterBuilder extends StatelessWidget {
  const AppRouterBuilder({
    super.key,
    required this.router,
  });

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return Router(
      backButtonDispatcher: AutoRouteBackButtonDispatcher(
        context,
        router,
        onFirstPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: FText("Double press to exit"),
            ),
          );
        },
      ),
      routerDelegate: AutoRouterDelegate(
        router,
      ),
    );
  }
}

class AutoRouteBackButtonDispatcher extends RootBackButtonDispatcher {
  DateTime? _lastPressTime;

  final void Function() onFirstPress;

  final RootStackRouter router;
  final BuildContext context;

  AutoRouteBackButtonDispatcher(
    this.context,
    this.router, {
    required this.onFirstPress,
  });

  @override
  Future<bool> didPopRoute() async {
    if (router.canPop()) {
      return super.didPopRoute();
    } else {
      final DateTime now = DateTime.now();

      if (_lastPressTime == null ||
          now.difference(_lastPressTime!) > const Duration(seconds: 2)) {
        _lastPressTime = now;
        onFirstPress();
      } else {
        return false;
      }

      return true;
    }
  }
}
