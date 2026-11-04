// ignore_for_file: unused_import
import 'package:auto_route/auto_route.dart';
import 'package:flags/features/flag_games/picker/flappy_flag_picker_screen.dart';
import 'package:flags/features/flag_games/zambia/flappy_game_screen.dart';
import 'package:flags/features/flag_games/tanzania/traffic_game_screen.dart';
import 'package:flags/features/flag_games/angola/knife_hit_screen.dart';
import 'package:flags/features/flag_games/kosovo/kosovo_game_screen.dart';
import 'package:flags/features/flag_games/japan/japan_knife_hit_screen.dart';
import 'package:flags/features/flag_games/cambodia/cambodia_game_screen.dart';
import 'package:flags/features/flag_games/israel/israel_game_screen.dart';
import 'package:flags/features/flag_games/kiribati/kiribati_game_screen.dart';
import 'package:flutter/material.dart';
import 'router.gr.dart';

Widget _slideFromRight(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  AppRouter({
    super.navigatorKey,
  });

  @override
  RouteType get defaultRouteType => RouteType.custom();

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
          page: FlappyFlagPickerRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: FlappyGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: TrafficGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: KnifeHitRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: KosovoGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: JapanKnifeHitRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: CambodiaGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: IsraelGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
        ),
        CustomRoute(
          page: KiribatiGameRoute.page,
          transitionsBuilder: _slideFromRight,
          durationInMilliseconds: 250,
          reverseDurationInMilliseconds: 250,
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
