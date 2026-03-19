import 'package:auto_route/auto_route.dart';
import 'router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  AppRouter({
    super.navigatorKey,
  });

  @override
  RouteType get defaultRouteType => const RouteType.custom();

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          initial: true,
          page: HomeRoute.page,
        ),
        CustomRoute(
          page: GameServicesAccountRoute.page,
        ),
        CustomRoute(
          page: GameModePickerRouter.page,
          children: [
            CustomRoute(
              initial: true,
              page: GameModePickerRoute.page,
            ),
            CustomRoute(
              page: ContinentsPickerRouter.page,
              children: [
                CustomRoute(
                  initial: true,
                  page: ContinentsPickerRoute.page,
                ),
                CustomRoute(
                  page: LevelsPickerRouter.page,
                  children: [
                    CustomRoute(
                      initial: true,
                      page: LevelsPickerRoute.page,
                    ),
                    CustomRoute(
                      page: GamesFactoryRoute.page,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        CustomRoute(
          page: EditorRouter.page,
          children: [
            CustomRoute(
              page: MyFlagsRoute.page,
            ),
            CustomRoute(
              page: EditorRoute.page,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
