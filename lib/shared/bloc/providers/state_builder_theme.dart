import 'package:flutter/cupertino.dart';

class BlocStateBuilderThemeProvider extends InheritedWidget {
  final Widget Function()? buildLoader;

  const BlocStateBuilderThemeProvider({
    super.key,
    required super.child,
    this.buildLoader,
  });

  static BlocStateBuilderThemeProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlocStateBuilderThemeProvider>();
  }

  @override
  bool updateShouldNotify(covariant BlocStateBuilderThemeProvider oldWidget) {
    return oldWidget.buildLoader != buildLoader;
  }
}
