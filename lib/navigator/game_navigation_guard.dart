import 'package:auto_route/auto_route.dart';
import 'package:flags/logger.dart';

class GameNavigationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next();
  }

}
