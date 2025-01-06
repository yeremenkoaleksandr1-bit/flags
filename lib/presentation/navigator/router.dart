import 'package:auto_route/auto_route.dart';
import 'package:flags/presentation/navigator/router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  AppRouter({
    super.navigatorKey,
  });

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
        ),
        AutoRoute(
          page: EditorRouter.page,
          children: [
            AutoRoute(
              page: MyFlagsRoute.page,
            ),
            AutoRoute(
              page: EditorRoute.page,
            ),
          ],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
// class AppRouter extends QRouterDelegate {
//   static final RouteObserver<ModalRoute<void>> routeObserver =
//       RouteObserver<ModalRoute<void>>();
//
//   AppRouter({
//     super.initPath = '/home',
//     super.alwaysAddInitPath,
//     super.observers,
//     super.restorationScopeId,
//     super.withWebBar = false,
//     QRoute? unknownRoute,
//     Widget? initPage,
//   }) : super(
//           [
//             QRoute(
//               path: '/home',
//               name: Routes.home,
//               builder: () => HomeScreen(
//                 controller: (context) => HomePresenterImpl(),
//               ),
//             ),
//             QRoute(
//               path: '/game_mode_picker',
//               name: Routes.gameModePicker,
//               builder: () => GameModePickerScreen(
//                 controller: (context) => GameModePickerPresenterImpl(),
//               ),
//             ),
//             QRoute(
//               path: '/continents_picker',
//               name: Routes.continentsPicker,
//               builder: () {
//                 final data =
//                     QR.params['data']!.value! as ContinentPickerRouteParams;
//
//                 return ContinentsPickerScreen(
//                   controller: (context) => ContinentsPickerPresenterImpl(
//                     routeParams: data,
//                   ),
//                 );
//               },
//             ),
//             QRoute(
//               path: '/levels_picker',
//               name: Routes.levelsPicker,
//               builder: () => LevelsPickerScreen(
//                 controller: (context) {
//                   final data =
//                       QR.params['data']!.value! as LevelsPickerRouteParams;
//                   return LevelsPickerCubitImpl(params: data);
//                 },
//               ),
//             ),
//             QRoute(
//               path: '/game_process_factory',
//               name: Routes.gameProcessFactory,
//               builder: () {
//                 final data =
//                     QR.params['data']!.value! as GamesFactoryPageParams;
//                 return Overlayment(
//                   child: GamesFactoryPage(params: data),
//                 );
//               },
//             ),
//
//             QRoute.withChild(
//               observers: [GamePageBuilder.routeObserver],
//               path: '/editor',
//               children: [
//                 QRoute(
//                   path: '/gallery',
//                   name: Routes.myFlagsGallery,
//                   builder: () => const MyFlagsScreen(),
//                 ),
//                 QRoute(
//                   path: '/flag',
//                   name: Routes.editFlag,
//                   builder: () {
//                     final data = QR.params['data']!.value! as EditorFlagData;
//                     return BlocProvider<IFlagEditorCubit>(
//                       create: (context) => FlagEditorCubit(data),
//                       child: const EditorScreen(),
//                     );
//                   },
//                 ),
//               ],
//               builderChild: (QRouter router) {
//                 return BlocProvider(
//                   create: (BuildContext context) => MyFlagsCubit(),
//                   child: router,
//                 );
//               },
//             ),
//           ],
//         ) {
//     //  QR.settings.globalMiddlewares.add(_easyLoadingMiddleware);
//     //  QR.settings.logger = logger.t;
//
//     QR.settings.pagesType = const QCustomPage(
//       transitionDuration: Duration(milliseconds: 500),
//       reverseTransitionDuration: Duration(milliseconds: 500),
//       transitionsBuilder: buildTransitions,
//     );
//
//     if (unknownRoute != null) {
//       QR.settings.notFoundPage = unknownRoute;
//     }
//
//     if (initPage != null) {
//       QR.settings.initPage = initPage;
//     }
//   }
//
//   static Widget buildTransitions<T>(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return child;
//   }
//
//   RouteInformationParser<Object>? routeInformationParser =
//       const QRouteInformationParser();
// }
