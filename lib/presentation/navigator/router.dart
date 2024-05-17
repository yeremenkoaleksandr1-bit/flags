import 'package:state_manager/state_manager.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/presentation/presenters/game_mode_picker/game_mode_picker.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/route_params.dart';
import 'package:flags/presentation/presenters/my_flags/my_flags.presenter.dart';
import 'package:flags/screens/continents_picker/continents_picker.screen.dart';
import 'package:flags/screens/editor/editor/editor.screen.dart';
import 'package:flags/screens/editor/my_flags/my_flags.screen.dart';
import 'package:flags/screens/game_mode_picker/game_mode_picker.screen.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:flags/screens/home/home.screen.dart';
import 'package:flags/screens/levels_picker/levels_picker.screen.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/layout_components/overlayment/overlayment.provider.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRouter extends QRouterDelegate {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

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
                routeObserver,
                GetScreen.routeObserver,
                GamePageBuilder.routeObserver,
                HeroController(),
              ],
              builderChild: (router) => router,
              children: [
                QRoute(
                  path: '/home',
                  name: Routes.home,
                  builder: () => HomeScreen(
                    controller: (context) => HomePresenterImpl(),
                  ),
                ),
                QRoute(
                  path: '/game_mode_picker',
                  name: Routes.gameModePicker,
                  builder: () => GameModePickerScreen(
                    controller: (context) => GameModePickerPresenterImpl(),
                  ),
                ),
                QRoute(
                  path: '/continents_picker',
                  name: Routes.continentsPicker,
                  builder: () {
                    final data =
                        QR.params['data']!.value! as ContinentPickerRouteParams;

                    return ContinentsPickerScreen(
                      controller: (context) => ContinentsPickerPresenterImpl(
                        routeParams: data,
                      ),
                    );
                  },
                ),
                QRoute(
                  path: '/levels_picker',
                  name: Routes.levelsPicker,
                  builder: () => LevelsPickerScreen(
                    controller: (context) {
                      final data =
                          QR.params['data']!.value! as LevelsPickerRouteParams;
                      return LevelsPickerPresenterImpl(params: data);
                    },
                  ),
                ),
                QRoute(
                  path: '/game_process_factory',
                  name: Routes.gameProcessFactory,
                  builder: () {
                    final data =
                        QR.params['data']!.value! as GamesFactoryPageParams;
                    return Overlayment(
                      child: GamesFactoryPage(params: data),
                    );
                  },
                ),
                QRoute(
                  path: '/my_flags',
                  name: Routes.myFlags,
                  builder: () => MyFlagsScreen(
                    controller: (context) => MyFlagsPresenterImpl(),
                  ),
                ),
                QRoute(
                  path: '/editor',
                  name: Routes.editor,
                  builder: () {
                    final data = QR.params['data']!.value! as EditorFlagData;
                    return EditorScreen(
                      controller: (context) => EditorPresenterImpl(data),
                    );
                  },
                ),
              ],
            ),
          ],
        ) {
    //  QR.settings.globalMiddlewares.add(_easyLoadingMiddleware);
    //  QR.settings.logger = logger.t;
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
