import 'package:armar/contexts/contexts.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRouterBuilder extends StatelessWidget {
  const AppRouterBuilder({
    super.key,
    required this.router,
  });

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return Router(
      backButtonDispatcher: DoubleTapBackButtonDispatcher(
        onFirstPress: () {
          ScaffoldMessenger.of(ArAppContexts.globalScaffold).showSnackBar(
            SnackBar(
              content: FText("double_press_exit_message"),
            ),
          );
        },
      ),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router,
      restorationScopeId: router.restorationScopeId,
    );
  }
}

class DoubleTapBackButtonDispatcher extends RootBackButtonDispatcher {
  DateTime? _lastPressTime;

  final void Function() onFirstPress;

  DoubleTapBackButtonDispatcher({required this.onFirstPress});

  @override
  Future<bool> didPopRoute() async {
    if (QR.history.length > 2) {
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
