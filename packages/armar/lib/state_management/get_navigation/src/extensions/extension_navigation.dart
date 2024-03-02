import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../get.dart';
import '../../get_navigation.dart';
import '../dialog/dialog_route.dart';
import '../root/get_root.dart';

/// It replaces the Flutter Navigator, but needs no context.
/// You can to use navigator.push(YourRoute()) rather
/// Navigator.push(context, YourRoute());
//NavigatorState? get navigator => GetNavigationExt(Get).key.currentState;

extension GetNavigationExt on GetInterface {
  /// **Navigation.push()** shortcut.<br><br>
  ///
  /// Pushes a new `page` to the stack
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  // Future<T?>? to<T>(Widget Function() page,
  //     {bool? opaque,
  //    // Transition? transition,
  //     Curve? curve,
  //     Duration? duration,
  //     int? id,
  //     String? routeName,
  //     bool fullscreenDialog = false,
  //     dynamic arguments,
  //     List<BindingsInterface> bindings = const [],
  //     bool preventDuplicates = true,
  //     bool? popGesture,
  //     bool showCupertinoParallax = true,
  //     double Function(BuildContext context)? gestureWidth,
  //     bool rebuildStack = true,
  //     PreventDuplicateHandlingMode preventDuplicateHandlingMode =
  //         PreventDuplicateHandlingMode.reorderRoutes}) {
  //   return searchDelegate(id).to(
  //     page,
  //     opaque: opaque,
  //     transition: transition,
  //     curve: curve,
  //     duration: duration,
  //     id: id,
  //     routeName: routeName,
  //     fullscreenDialog: fullscreenDialog,
  //     arguments: arguments,
  //     bindings: bindings,
  //     preventDuplicates: preventDuplicates,
  //     popGesture: popGesture,
  //     showCupertinoParallax: showCupertinoParallax,
  //     gestureWidth: gestureWidth,
  //     rebuildStack: rebuildStack,
  //     preventDuplicateHandlingMode: preventDuplicateHandlingMode,
  //   );
  // }

//   GetPageBuilder _resolvePage(dynamic page, String method) {
//     if (page is GetPageBuilder) {
//       return page;
//     } else if (page is Widget) {
//       Get.log(
//           '''WARNING, consider using: "Get.$method(() => Page())"
//instead of "Get.$method(Page())".
// Using a widget function instead of a widget fully guarantees that the widget
//and its controllers will be removed from memory when they are no longer used.
//       ''');
//       return () => page;
//     } else if (page is String) {
//       throw '''Unexpected String,
// use toNamed() instead''';
//     } else {
//       throw '''Unexpected format,
// you can only use widgets and widget functions here''';
//     }
//   }

  /// **Navigation.pushNamed()** shortcut.<br><br>
  ///
  /// Pushes a new named `page` to the stack.
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  // Future<T?>? toNamed<T>(
  //   String page, {
  //   dynamic arguments,
  //   dynamic id,
  //   bool preventDuplicates = true,
  //   Map<String, String>? parameters,
  //   PreventDuplicateHandlingMode mode =
  //       PreventDuplicateHandlingMode.reorderRoutes,
  //   LocalKey? key,
  // }) {
  //   if (preventDuplicates && page == currentRoute) {
  //     return null;
  //   }
  //
  //   if (parameters != null) {
  //     final uri = Uri(path: page, queryParameters: parameters);
  //     page = uri.toString();
  //   }
  //
  //   return searchDelegate(id).toNamed(
  //     page,
  //     arguments: arguments,
  //     id: id,
  //     preventDuplicates: preventDuplicates,
  //     parameters: parameters,
  //     key: key,
  //   );
  // }

  // Future<T?>? pushNamed<T>(
  //   String page, {
  //   dynamic arguments,
  //   dynamic id,
  //   bool preventDuplicates = true,
  //   Map<String, String>? parameters,
  //   PreventDuplicateHandlingMode mode =
  //       PreventDuplicateHandlingMode.reorderRoutes,
  // }) {
  //   // if (preventDuplicates && page == currentRoute) {
  //   //   return null;
  //   // }
  //
  //   if (parameters != null) {
  //     final uri = Uri(path: page, queryParameters: parameters);
  //     page = uri.toString();
  //   }
  //
  //   return searchDelegate(id).pushNamed(
  //     page,
  //     arguments: arguments,
  //     id: id,
  //     preventDuplicates: preventDuplicates,
  //     parameters: parameters,
  //   );
  // }

  /// **Navigation.pushReplacementNamed()** shortcut.<br><br>
  ///
  /// Pop the current named `page` in the stack and push a new one in its place
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  // Future<T?>? offNamed<T>(
  //   String page, {
  //   dynamic arguments,
  //   int? id,
  //   Map<String, String>? parameters,
  // }) {
  //   // if (preventDuplicates && page == currentRoute) {
  //   //   return null;
  //   // }
  //
  //   if (parameters != null) {
  //     final uri = Uri(path: page, queryParameters: parameters);
  //     page = uri.toString();
  //   }
  //   return searchDelegate(id).offNamed(
  //     page,
  //     arguments: arguments,
  //     id: id,
  //     // preventDuplicates: preventDuplicates,
  //     parameters: parameters,
  //   );
  // }

  /// **Navigation.popUntil()** shortcut.<br><br>
  ///
  /// Calls pop several times in the stack until [predicate] returns true
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  ///
  /// or also like this:
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the
  /// dialog is closed
  // void until(bool Function(GetPage<dynamic>) predicate, {int? id}) {
  //   // if (key.currentState.mounted) // add this if appear problems on future with route navigate
  //   // when widget don't mounted
  //   return searchDelegate(id).backUntil(predicate);
  // }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push the given named `page`, and then pop several pages in the stack
  /// until [predicate] returns true
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.offNamedUntil(page, ModalRoute.withName('/home'))`
  /// to pop routes in stack until home,
  /// or like this:
  /// `Get.offNamedUntil((route) => !Get.isDialogOpen())`,
  /// to make sure the dialog is closed
  ///
  /// Note: Always put a slash on the route name ('/page1'), to avoid unexpected errors
  // Future<T?>? offNamedUntil<T>(
  //   String page,
  //   bool Function(GetPage<dynamic>)? predicate, {
  //   int? id,
  //   dynamic arguments,
  //   Map<String, String>? parameters,
  // }) {
  //   if (parameters != null) {
  //     final uri = Uri(path: page, queryParameters: parameters);
  //     page = uri.toString();
  //   }
  //
  //   return searchDelegate(id).offNamedUntil<T>(
  //     page,
  //     predicate: predicate,
  //     id: id,
  //     arguments: arguments,
  //     parameters: parameters,
  //   );
  // }

  /// **Navigation.popAndPushNamed()** shortcut.<br><br>
  ///
  /// Pop the current named page and pushes a new `page` to the stack
  /// in its place
  ///
  /// You can send any type of value to the other route in the [arguments].
  /// It is very similar to `offNamed()` but use a different approach
  ///
  /// The `offNamed()` pop a page, and goes to the next. The
  /// `offAndToNamed()` goes to the next page, and removes the previous one.
  /// The route transition animation is different.
  // Future<T?>? offAndToNamed<T>(
  //   String page, {
  //   dynamic arguments,
  //   int? id,
  //   dynamic result,
  //   Map<String, String>? parameters,
  // }) {
  //   if (parameters != null) {
  //     final uri = Uri(path: page, queryParameters: parameters);
  //     page = uri.toString();
  //   }
  //   return searchDelegate(id).backAndToNamed(
  //     page,
  //     arguments: arguments,
  //     result: result,
  //   );
  // }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  ///
  /// Remove a specific [route] from the stack
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  // void removeRoute(String name, {int? id}) {
  //   return searchDelegate(id).removeRoute(name);
  // }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push a named `page` and pop several pages in the stack
  /// until [predicate] returns true. [predicate] is optional
  ///
  /// It has the advantage of not needing context, so you can
  /// call from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unexpected errors
  // Future<T?>? offAllNamed<T>(
  //   String newRouteName, {
  //   // bool Function(GetPage<dynamic>)? predicate,
  //   dynamic arguments,
  //   int? id,
  //   Map<String, String>? parameters,
  // }) {
  //   if (parameters != null) {
  //     final uri = Uri(path: newRouteName, queryParameters: parameters);
  //     newRouteName = uri.toString();
  //   }
  //
  //   return searchDelegate(id).offAllNamed<T>(
  //     newRouteName,
  //     //predicate: predicate ?? (_) => false,
  //     arguments: arguments,
  //     id: id,
  //     parameters: parameters,
  //   );
  // }

  /// **Navigation.popUntil()** shortcut.<br><br>
  ///
  /// Pop the current page, snackbar, dialog or bottomsheet in the stack
  ///
  /// if your set [closeOverlays] to true, Get.back() will close the
  /// currently open snackbar/dialog/bottomsheet AND the current page
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  // void back<T>({
  //   T? result,
  //   bool canPop = true,
  //   int? id,
  // }) async {
  //   //TODO: remove this when change own api to Dialog and BottomSheets
  //   //to declarative way
  //   if (Navigator.of(Get.context!).canPop()) {
  //     searchDelegate(id).navigatorKey.currentState?.pop(result);
  //     return;
  //   }
  //
  //   if (canPop) {
  //     if (searchDelegate(id).canBack == true) {
  //       searchDelegate(id).back<T>(result);
  //     }
  //   } else {
  //     searchDelegate(id).back<T>(result);
  //   }
  // }

  /// **Navigation.popUntil()** (with predicate) shortcut .<br><br>
  ///
  /// Close as many routes as defined by [times]
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  // void close(int times, [int? id]) {
  //   if (times < 1) {
  //     times = 1;
  //   }
  //   var count = 0;
  //   var back = searchDelegate(id).backUntil((route) => count++ == times);
  //
  //   return back;
  // }

  /// **Navigation.pushReplacement()** shortcut .<br><br>
  ///
  /// Pop the current page and pushes a new `page` to the stack
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], define a Tween [curve],
  /// and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  // Future<T?>? off<T>(
  //   Widget Function() page, {
  //   bool? opaque,
  //   Transition? transition,
  //   Curve? curve,
  //   bool? popGesture,
  //   int? id,
  //   String? routeName,
  //   dynamic arguments,
  //   List<BindingsInterface> bindings = const [],
  //   bool fullscreenDialog = false,
  //   bool preventDuplicates = true,
  //   Duration? duration,
  //   double Function(BuildContext context)? gestureWidth,
  // }) {
  //   routeName ??= "/${page.runtimeType.toString()}";
  //   routeName = _cleanRouteName(routeName);
  //   if (preventDuplicates && routeName == currentRoute) {
  //     return null;
  //   }
  //   return searchDelegate(id).off(
  //     page,
  //     opaque: opaque ?? true,
  //     transition: transition,
  //     curve: curve,
  //     popGesture: popGesture,
  //     id: id,
  //     routeName: routeName,
  //     arguments: arguments,
  //     bindings: bindings,
  //     fullscreenDialog: fullscreenDialog,
  //     preventDuplicates: preventDuplicates,
  //     duration: duration,
  //     gestureWidth: gestureWidth,
  //   );
  // }
  //
  // Future<T?> offUntil<T>(
  //   Widget Function() page,
  //   bool Function(GetPage) predicate, [
  //   Object? arguments,
  //   int? id,
  // ]) {
  //   return searchDelegate(id).offUntil(
  //     page,
  //     predicate,
  //     arguments,
  //   );
  // }

  ///
  /// Push a `page` and pop several pages in the stack
  /// until [predicate] returns true. [predicate] is optional
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], a [curve] and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  // Future<T?>? offAll<T>(
  //   Widget Function() page, {
  //   bool Function(GetPage<dynamic>)? predicate,
  //   bool? opaque,
  //   bool? popGesture,
  //   int? id,
  //   String? routeName,
  //   dynamic arguments,
  //   List<BindingsInterface> bindings = const [],
  //   bool fullscreenDialog = false,
  //   Transition? transition,
  //   Curve? curve,
  //   Duration? duration,
  //   double Function(BuildContext context)? gestureWidth,
  // }) {
  //   routeName ??= "/${page.runtimeType.toString()}";
  //   routeName = _cleanRouteName(routeName);
  //   return searchDelegate(id).offAll<T>(
  //     page,
  //     predicate: predicate,
  //     opaque: opaque ?? true,
  //     popGesture: popGesture,
  //     id: id,
  //     //  routeName routeName,
  //     arguments: arguments,
  //     bindings: bindings,
  //     fullscreenDialog: fullscreenDialog,
  //     transition: transition,
  //     curve: curve,
  //     duration: duration,
  //     gestureWidth: gestureWidth,
  //   );
  // }

  /// Takes a route [name] String generated by [to], [off], [offAll]
  /// (and similar context navigation methods), cleans the extra chars and
  /// accommodates the format.
  /// TODO: check for a more "appealing" URL naming convention.
  /// `() => MyHomeScreenView` becomes `/my-home-screen-view`.
  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  //TODO: Deprecated
  // /// change default config of Get
  // void config(
  //     {bool? enableLog,
  //     LogWriterCallback? logWriterCallback,
  //     bool? defaultPopGesture,
  //     bool? defaultOpaqueRoute,
  //     Duration? defaultDurationTransition,
  //     bool? defaultGlobalState,
  //     Transition? defaultTransition}) {
  //   if (enableLog != null) {
  //     Get.isLogEnable = enableLog;
  //   }
  //   if (logWriterCallback != null) {
  //     Get.log = logWriterCallback;
  //   }
  //   if (defaultPopGesture != null) {
  //     _getxController.defaultPopGesture = defaultPopGesture;
  //   }
  //   if (defaultOpaqueRoute != null) {
  //     _getxController.defaultOpaqueRoute = defaultOpaqueRoute;
  //   }
  //   if (defaultTransition != null) {
  //     _getxController.defaultTransition = defaultTransition;
  //   }

  //   if (defaultDurationTransition != null) {
  //     _getxController.defaultTransitionDuration = defaultDurationTransition;
  //   }
  // }

  Future<void> updateLocale(Locale l) async {
    Get.locale = l;
    await forceAppUpdate();
  }

  /// As a rule, Flutter knows which widget to update,
  /// so this command is rarely needed. We can mention situations
  /// where you use const so that widgets are not updated with setState,
  /// but you want it to be forcefully updated when an event like
  /// language change happens. using context to make the widget dirty
  /// for performRebuild() is a viable solution.
  /// However, in situations where this is not possible, or at least,
  /// is not desired by the developer, the only solution for updating
  /// widgets that Flutter does not want to update is to use reassemble
  /// to forcibly rebuild all widgets. Attention: calling this function will
  /// reconstruct the application from the sketch, use this with caution.
  /// Your entire application will be rebuilt, and touch events will not
  /// work until the end of rendering.
  Future<void> forceAppUpdate() async {
    await engine.performReassemble();
  }

  void appUpdate() => rootController.update();

  void changeTheme(ThemeData theme) {
    rootController.setTheme(theme);
  }

  void changeThemeMode(ThemeMode themeMode) {
    rootController.setThemeMode(themeMode);
  }

  // GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
  //   return rootController.addKey(newKey);
  // }
  //
  // GetDelegate? nestedKey(String? key) {
  //   return rootController.nestedKey(key);
  // }
  //
  // GetDelegate searchDelegate(dynamic k) {
  //   GetDelegate key;
  //   if (k == null) {
  //     key = Get.rootController.rootDelegate;
  //   } else {
  //     if (!keys.containsKey(k)) {
  //       throw 'Route id ($k) not found';
  //     }
  //     key = keys[k]!;
  //   }
  //
  //   // if (_key.listenersLength == 0 && !testMode) {
  //   //   throw """You are trying to use contextless navigation without
  //   //   a GetMaterialApp or Get.key.
  //   //   If you are testing your app, you can use:
  //   //   [Get.testMode = true], or if you are running your app on
  //   //   a physical device or emulator, you must exchange your [MaterialApp]
  //   //   for a [GetMaterialApp].
  //   //   """;
  //   // }
  //
  //   return key;
  // }
  //
  // /// give current arguments
  // //dynamic get arguments => routing.args;
  // dynamic get arguments => rootController.rootDelegate.arguments();
  //
  // GetDelegate get rootDelegate => rootController.rootDelegate;
  //
  // GetPage<dynamic>? get page =>
  //     rootController.rootDelegate.currentConfiguration?.route;
  //
  // /// give name from current route
  // String get currentRoute => routing.current;
  //
  // Routing get currentRouting => routing;
  //
  // /// give name from previous route
  // String get previousRoute => routing.previous;
  //
  // /// check if dialog is open
  // bool? get isDialogOpen => routing.isDialog;
  //
  // /// check if bottomsheet is open
  // bool? get isBottomSheetOpen => routing.isBottomSheet;
  //
  // /// check a raw current route
  // Route<dynamic>? get rawRoute => routing.route;

  /// check if popGesture is enable
  bool get isPopGestureEnable => defaultPopGesture;

  /// check if default opaque route is enable
  bool get isOpaqueRouteDefault => defaultOpaqueRoute;

  /// give access to currentContext
  // BuildContext? get context => key.currentContext;
  //
  // get dTest => key;

  /// give access to current Overlay Context
  // BuildContext? get overlayContext {
  //   BuildContext? overlay;
  //   key.currentState?.overlay?.context.visitChildElements((element) {
  //     overlay = element;
  //   });
  //   return overlay;
  // }

  /// give access to Theme.of(context)
  // ThemeData get theme {
  //   var theme = ThemeData.fallback();
  //   if (context != null) {
  //     theme = Theme.of(context!);
  //   }
  //   return theme;
  // }

  /// The current null safe [WidgetsBinding]
  WidgetsBinding get engine {
    return WidgetsFlutterBinding.ensureInitialized();
  }

  /// The window to which this binding is bound.
  ui.SingletonFlutterWindow get window => engine.window;

  Locale? get deviceLocale => engine.window.locale;

  ///The number of device pixels for each logical pixel.
  double get pixelRatio => engine.window.devicePixelRatio;

  Size get size => engine.window.physicalSize / pixelRatio;

  ///The horizontal extent of this size.
  double get width => size.width;

  ///The vertical extent of this size
  double get height => size.height;

  ///The distance from the top edge to the first unpadded pixel,
  ///in physical pixels.
  double get statusBarHeight => engine.window.padding.top;

  ///The distance from the bottom edge to the first unpadded pixel,
  ///in physical pixels.
  double get bottomBarHeight => engine.window.padding.bottom;

  ///The system-reported text scale.
  double get textScaleFactor => engine.window.textScaleFactor;

  /// give access to TextTheme.of(context)
 // TextTheme get textTheme => theme.textTheme;

  /// give access to Mediaquery.of(context)
 // MediaQueryData get mediaQuery => MediaQuery.of(context!);

  /// Check if dark mode theme is enable
 // bool get isDarkMode => (theme.brightness == Brightness.dark);

  /// Check if dark mode theme is enable on platform on android Q+
  // bool get isPlatformDarkMode =>
  //     (ui.window.platformBrightness == Brightness.dark);

  /// give access to Theme.of(context).iconTheme.color
//  Color? get iconColor => theme.iconTheme.color;

  /// give access to FocusScope.of(context)
  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  // /// give access to Immutable MediaQuery.of(context).size.height
  // double get height => MediaQuery.of(context).size.height;

  // /// give access to Immutable MediaQuery.of(context).size.width
  // double get width => MediaQuery.of(context).size.width;

  // GlobalKey<NavigatorState> get key => rootController.key;
  //
  // Map<dynamic, GetDelegate> get keys => rootController.keys;

  GetRootState get rootController => GetRootState.controller;

  ConfigData get _getxController => GetRootState.controller.config;

  bool get defaultPopGesture => _getxController.defaultPopGesture;

  bool get defaultOpaqueRoute => _getxController.defaultOpaqueRoute;

 // Transition? get defaultTransition => _getxController.defaultTransition;

  Duration get defaultTransitionDuration {
    return _getxController.defaultTransitionDuration;
  }

  Curve get defaultTransitionCurve => _getxController.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve {
    return _getxController.defaultDialogTransitionCurve;
  }

  Duration get defaultDialogTransitionDuration {
    return _getxController.defaultDialogTransitionDuration;
  }

 // Routing get routing => _getxController.routing;

  set parameters(Map<String, String?> newParameters) =>
      rootController.parameters = newParameters;

  set testMode(bool isTest) => rootController.testMode = isTest;

  bool get testMode => _getxController.testMode;

 // Map<String, String?> get parameters => rootController.rootDelegate.parameters;

  /// Casts the stored router delegate to a desired type
  // TDelegate? delegate<TDelegate extends RouterDelegate<TPage>, TPage>() =>
  //     _getxController.routerDelegate as TDelegate?;
}

extension OverlayExt on GetInterface {
  // Future<T> showOverlay<T>({
  //   required Future<T> Function() asyncFunction,
  //   Color opacityColor = Colors.black,
  //   Widget? loadingWidget,
  //   double opacity = .5,
  // }) async {
  //   final navigatorState =
  //       Navigator.of(Get.overlayContext!, rootNavigator: false);
  //   final overlayState = navigatorState.overlay!;
  //
  //   final overlayEntryOpacity = OverlayEntry(builder: (context) {
  //     return Opacity(
  //         opacity: opacity,
  //         child: Container(
  //           color: opacityColor,
  //         ));
  //   });
  //   final overlayEntryLoader = OverlayEntry(
  //     builder: (context) {
  //       return loadingWidget ??
  //           const Center(
  //             child: SizedBox(
  //               height: 90,
  //               width: 90,
  //               child: Text('Loading...'),
  //             ),
  //           );
  //     },
  //   );
  //   overlayState.insert(overlayEntryOpacity);
  //   overlayState.insert(overlayEntryLoader);
  //
  //   T data;
  //
  //   try {
  //     data = await asyncFunction();
  //   } on Exception catch (_) {
  //     overlayEntryLoader.remove();
  //     overlayEntryOpacity.remove();
  //     rethrow;
  //   }
  //
  //   overlayEntryLoader.remove();
  //   overlayEntryOpacity.remove();
  //   return data;
  // }
}
