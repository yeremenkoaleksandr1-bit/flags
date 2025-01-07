import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

class GameAutoRouteObserver extends AutoRouterObserver {
  final Map<LocalKey, Set<AutoRouteAware>> _listeners =
      <LocalKey, Set<AutoRouteAware>>{};
  void subscribe(AutoRouteAware routeAware, RouteData route) {
    final Set<AutoRouteAware> subscribers =
    _listeners.putIfAbsent(route.key, () => <AutoRouteAware>{});
    if (subscribers.add(routeAware)) {
      if (route.router is TabsRouter) {
        routeAware.didInitTabRoute(null);
      } else {
        routeAware.didPush();
      }
    }
  }

  void unsubscribe(AutoRouteAware routeAware) {
    for (final route in _listeners.keys) {
      final Set<AutoRouteAware>? subscribers = _listeners[route];
      subscribers?.remove(routeAware);
    }
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    final List<AutoRouteAware>? subscribers = _listeners[route.routeInfo.key]?.toList();
    if (subscribers != null) {
      for (final AutoRouteAware routeAware in subscribers) {
        routeAware.didInitTabRoute(previousRoute);
      }
    }
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    final List<AutoRouteAware>? subscribers = _listeners[route.routeInfo.key]?.toList();
    if (subscribers != null) {
      for (final AutoRouteAware routeAware in subscribers) {
        routeAware.didChangeTabRoute(previousRoute);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings is AutoRoutePage && previousRoute?.settings is AutoRoutePage) {
      final previousKey = (previousRoute!.settings as AutoRoutePage).routeKey;
      final List<AutoRouteAware>? previousSubscribers = _listeners[previousKey]?.toList();

      if (previousSubscribers != null) {
        for (final AutoRouteAware routeAware in previousSubscribers) {
          routeAware.didPopNext();
        }
      }
      final key = (route.settings as AutoRoutePage).routeKey;

      final List<AutoRouteAware>? subscribers = _listeners[key]?.toList();

      if (subscribers != null) {
        for (final AutoRouteAware routeAware in subscribers) {
          routeAware.didPop();
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings is AutoRoutePage && previousRoute?.settings is AutoRoutePage) {
      final previousKey = (previousRoute!.settings as AutoRoutePage).routeKey;
      final Set<AutoRouteAware>? previousSubscribers = _listeners[previousKey];

      if (previousSubscribers != null) {
        for (final AutoRouteAware routeAware in previousSubscribers) {
          routeAware.didPushNext();
        }
      }
    }
  }
}
