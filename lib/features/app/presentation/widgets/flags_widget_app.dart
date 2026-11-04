import 'package:flutter/material.dart';

class FlagsWidgetsApp extends WidgetsApp {
  FlagsWidgetsApp({
    super.key,
    super.actions,
    super.debugShowCheckedModeBanner = false,
    super.locale,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.localizationsDelegates,
    super.onGenerateTitle,
    super.onNavigationNotification,
    super.supportedLocales,
    super.restorationScopeId,
    super.shortcuts,
    super.showPerformanceOverlay,
    super.showSemanticsDebugger,
    required ThemeData theme,
    super.navigatorKey,
    super.navigatorObservers,
    super.title,
    super.onGenerateRoute,
    super.onUnknownRoute,
    required TransitionBuilder builder,
    super.color = Colors.blueAccent,
  }) : super(
    builder: (context, child) {
      return Theme(
        data: theme,
        child: ScaffoldMessenger(
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium ?? const TextStyle(),
            child: builder(context, child),
          ),
        ),
      );
    },
  );
}
