import 'package:flags/features/game_state/game_state_cubit.dart';
import 'package:flags/ui/debug_paint.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:state_manager/state_manager.dart';

import '../uikit/drag_and_drop/provider.dart';
import 'app_builder.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameStateCubit(),
        ),
      ],
      child: StateMixinThemeProvider(
        child: FlagsWidgetsApp(
          title: "FlagsUp",
          theme: AppTheme.themeData,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, _) {
            return DragAndDropProvider(
              builder: (BuildContext context) {
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
          },
        ),
      ),
    );
  }
}

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
