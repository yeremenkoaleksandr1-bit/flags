import 'package:armar/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ArmarAppRouter extends MaterialApp {
  ArmarAppRouter({
    super.key,
    super.actions,
    super.checkerboardOffscreenLayers,
    super.checkerboardRasterCacheImages,
    super.color,
    super.darkTheme,
    super.debugShowCheckedModeBanner = false,
    super.debugShowMaterialGrid,
    super.highContrastDarkTheme,
    super.highContrastTheme,
    super.locale,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.localizationsDelegates,
    super.onGenerateTitle,
    super.onNavigationNotification,
    super.supportedLocales,
    super.restorationScopeId,
    super.scaffoldMessengerKey,
    super.scrollBehavior,
    super.shortcuts,
    super.showPerformanceOverlay,
    super.showSemanticsDebugger,
    ArmarThemeData? armarThemeData,
    super.themeAnimationCurve,
    super.themeAnimationDuration,
    super.themeMode,
    super.title,
    super.backButtonDispatcher,
    super.routeInformationParser,
    super.routeInformationProvider,
    super.routerConfig,
    super.routerDelegate,
    super.builder,
  }) : super.router(
          theme: () {
            final theme = armarThemeData ??
                ArmarThemeData(
                  materialTheme: ThemeData(),
                );

            return theme.materialTheme.copyWith(
              inputDecorationTheme: theme.textFieldTheme.toDecorationTheme(),
              extensions: [
                ...theme.materialTheme.extensions.values,
                ...theme.themes,
              ],
            );
          }(),
        );
}
