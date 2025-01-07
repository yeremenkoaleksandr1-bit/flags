import 'package:auto_route/auto_route.dart';
import 'package:flags/logger.dart';

class GameNavigationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    logger.d(router.current.name);
    resolver.next();
  }

}
