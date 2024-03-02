import 'package:armar/armar.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

import '../presentation/navigator/router.dart';
import '../uikit/theme/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "FlagsUp",
        routerDelegate: router,
        routeInformationParser: router.routeInformationParser,
        theme: AppTheme.themeData,
        builder: EasyLoading.init(),
      ),
    );
  }
}
