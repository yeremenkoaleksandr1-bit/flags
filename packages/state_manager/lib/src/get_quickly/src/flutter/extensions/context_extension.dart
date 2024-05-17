import 'package:fast_extensions/fast_extensions.dart';
import 'package:flutter/material.dart';

///Context extension to extend widget functionality
extension ContextExtension on BuildContext {
  /// similar to [Theme.of(context).textTheme.bodyLarge]
  TextStyle? get bodyLarge => textTheme.bodyLarge;

  /// similar to [Theme.of(context).textTheme.bodyMedium]
  TextStyle? get bodyMedium => textTheme.bodyMedium;

  /// similar to [Theme.of(context).textTheme.bodySmall]
  TextStyle? get bodySmall => textTheme.bodySmall;

  /// similar to [Theme.of(context).textTheme.displayLarge]
  TextStyle? get displayLarge => textTheme.displayLarge;

  /// similar to [Theme.of(context).textTheme.displayMedium]
  TextStyle? get displayMedium => textTheme.displayMedium;

  /// similar to [Theme.of(context).textTheme.displaySmall]
  TextStyle? get displaySmall => textTheme.displaySmall;

  /// similar to [Theme.of(context).textTheme.labelLarge]
  TextStyle? get labelLarge => textTheme.labelLarge;

  /// similar to [Theme.of(context).textTheme.labelMedium]
  TextStyle? get labelMedium => textTheme.labelMedium;

  /// similar to [Theme.of(context).textTheme.labelSmall]
  TextStyle? get labelSmall => textTheme.labelSmall;

  /// similar to [Theme.of(context).textTheme.headlineLarge]
  TextStyle? get headlineLarge => textTheme.headlineLarge;

  /// similar to [Theme.of(context).textTheme.headlineMedium]
  TextStyle? get headlineMedium => textTheme.headlineMedium;

  /// similar to [Theme.of(context).textTheme.headlineSmall]
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  /// similar to [Theme.of(context).textTheme.titleLarge]
  TextStyle? get titleLarge => textTheme.titleLarge;

  /// similar to [Theme.of(context).textTheme.titleMedium]
  TextStyle? get titleMedium => textTheme.titleMedium;

  /// similar to [Theme.of(context).textTheme.titleSmall]
  TextStyle? get titleSmall => textTheme.titleSmall;

  /// Returns the nearest ancestor [Navigator] widget.
  NavigatorState get navigator => Navigator.of(this);

  /// Shows a [SnackBar] with the given message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// Provides a shortcut to push a new route to the navigator.
  ///
  /// This is equivalent to calling `Navigator.of(context).push()`.
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  /// Provides a shortcut to push a named route to the navigator.
  ///
  /// This is equivalent to calling `Navigator.of(context).pushNamed()`.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);

  /// Provides a shortcut to pop the current route off the navigator.
  ///
  /// This is equivalent to calling `Navigator.of(context).pop()`.
  void pop<T>([T? result]) => navigator.pop<T>(result);
}
