import 'package:armar/contexts/contexts.dart';
import 'package:armar/logger.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/presentation/presenters/game_mode_picker/game_mode_picker.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/route_params.dart';
import 'package:flags/presentation/presenters/my_flags/my_flags.presenter.dart';
import 'package:flags/screens/continents_picker/continents_picker.screen.dart';
import 'package:flags/screens/editor/my_flags/my_flags.screen.dart';
import 'package:flags/screens/game_mode_picker/game_mode_picker.screen.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:flags/screens/levels_picker/levels_picker.screen.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../screens/home/home.screen.dart';
import '../../ui/builders/app/app_builder.dart';
import '../../ui/game_scaffold.dart';
import '../app/app.presenter.dart';
import '../presenters/continents_picker/route_params.dart';
import 'routes.dart';

class AppRouter extends QRouterDelegate {
  AppRouter({
    super.initPath = '/app',
    super.alwaysAddInitPath,
    super.observers,
    super.restorationScopeId,
    super.withWebBar = false,
    QRoute? unknownRoute,
    Widget? initPage,
  }) : super(
          [
            QRoute.withChild(
                path: '/app',
                initRoute: '/home',
                observers: [
                  GameTransitionPageBuilder.routeObserver,
                  HeroController(),
                ],
                builderChild: (router) {
                  return Builder(
                    builder: (BuildContext context) {
                      return AppScreen(
                        presenter: () => AppPresenterImpl(context: context),
                        router: router,
                      );
                    },
                  );
                },
                children: [
                  QRoute(
                    path: '/home',
                    name: Routes.home,
                    builder: () => HomeScreen(
                      presenter: () => HomePresenterImpl(),
                    ),
                  ),
                  QRoute(
                    path: '/game_mode_picker',
                    name: Routes.gameModePicker,
                    builder: () => GameModePickerScreen(
                      presenter: () => GameModePickerPresenterImpl(),
                    ),
                  ),
                  QRoute(
                    path: '/continents_picker',
                    name: Routes.continentsPicker,
                    builder: () {
                      final data = QR.params['data']!.value
                          as ContinentPickerRouteParams;

                      return ContinentsPickerScreen(
                        presenter: () => ContinentsPickerPresenterImpl(
                          routeParams: data,
                        ),
                      );
                    },
                  ),
                  QRoute(
                    path: '/levels_picker',
                    name: Routes.levelsPicker,
                    builder: () => LevelsPickerScreen(
                      presenter: () {
                        final data =
                            QR.params['data']!.value as LevelsPickerRouteParams;
                        return LevelsPickerPresenterImpl(params: data);
                      },
                    ),
                  ),
                  QRoute(
                    path: '/game_process_factory',
                    name: Routes.gameProcessFactory,
                    builder: () {
                      final data =
                          QR.params['data']!.value as GamesFactoryPageParams;
                      return GamesFactoryPage(params: data);
                    },
                  ),
                  QRoute(
                    path: '/my_flags',
                    name: Routes.myFlags,
                    builder: () => MyFlagsScreen(
                      presenter: () => MyFlagsPresenterImpl(),
                    ),
                  ),
                ]),
          ],
          navKey: ArAppContexts.keys.navigatorKey,
        ) {
    //  QR.settings.globalMiddlewares.add(_easyLoadingMiddleware);
    QR.settings.logger = logger.t;
    QR.settings.pagesType = const QCustomPage(
      transitionDuration: Duration(milliseconds: 500),
      reverseTransitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: buildTransitions,
    );

    if (unknownRoute != null) {
      QR.settings.notFoundPage = unknownRoute;
    }

    if (initPage != null) {
      QR.settings.initPage = initPage;
    }
  }

  static Widget buildTransitions<T>(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  RouteInformationParser<Object>? routeInformationParser =
      const QRouteInformationParser();
}
