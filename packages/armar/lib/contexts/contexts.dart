import 'package:flutter/widgets.dart';

base class ArAppKeys {
  final GlobalKey homeScaffoldKey = GlobalKey();

  final GlobalKey globalScaffoldKey = GlobalKey();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

abstract class ArAppContexts {
  static final ArAppKeys keys = ArAppKeys();

  static BuildContext get globalScaffold =>
      keys.globalScaffoldKey.currentContext!;

  static BuildContext get homeScaffold => keys.homeScaffoldKey.currentContext!;

  static BuildContext get navigator => keys.navigatorKey.currentContext!;
}
