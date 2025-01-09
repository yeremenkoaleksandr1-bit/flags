import 'package:auto_route/auto_route.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/logger.dart';
import 'package:flags/navigator/game_navigation_observer.dart';
import 'package:flags/navigator/router.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class AppRouterBuilder extends StatefulWidget {
  const AppRouterBuilder({
    super.key,
    required this.router,
  });

  final AppRouter router;

  @override
  State<AppRouterBuilder> createState() => _AppRouterBuilderState();
}

class _AppRouterBuilderState extends State<AppRouterBuilder> {
  @override
  void initState() {
    FlutterEngine.widgetPostFrameCallback((_) {
      widget.router.replaceAll([
        const HomeRoute(),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      restorationId: 'root-game',
      child: Router(
        backButtonDispatcher: AutoRouteBackButtonDispatcher(
          context,
          widget.router,
          onFirstPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Double press to exit"),
              ),
            );
          },
        ),
        routeInformationParser: widget.router.defaultRouteParser(),
        routerDelegate: AutoRouterDelegate(
          widget.router,
          navigatorObservers: () => [
            AutoRouteObserver(),
            GameAutoRouteObserver(),
          ],
        ),
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
