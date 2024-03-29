import 'package:armar/armar.dart';
import 'package:armar/armar_app.dart';
import 'package:flags/ui/debug_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../presentation/navigator/router.dart';
import '../ui/builders/app/app_builder.dart';
import '../uikit/theme/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FlagsWidgetsApp(
      title: "FlagsUp",
      theme: AppTheme.themeData,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, _) {
        return DebugPaintProvider(
          builder: (BuildContext context) {
            return EasyLoading.init()(
              context,
              AppScreen(),
            );
          },
        );
      },
    );
  }
}

class FlagsWidgetsApp extends WidgetsApp {
  FlagsWidgetsApp({
    super.key,
    super.actions,
    super.checkerboardOffscreenLayers,
    super.checkerboardRasterCacheImages,
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
    super.title,
    required TransitionBuilder builder,
    super.color = Colors.blueAccent,
  }) : super(
          builder: (context, child) {
            return Theme(
              data: theme,
              child: ScaffoldMessenger(
                child: builder(context, child),
              ),
            );
          },
        );
}
