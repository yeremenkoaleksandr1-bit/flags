import 'package:flutter/widgets.dart';

class StateMixinThemeProvider extends StatefulWidget {
  const StateMixinThemeProvider({
    super.key,
    required this.child,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });

  final Widget Function()? loadingBuilder;
  final Widget Function(String? error)? errorBuilder;
  final Widget? Function()? emptyBuilder;

  final Widget child;

  static StateMixinThemeProvider of(BuildContext context) {
    StateMixinThemeProviderState? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<StateMixinThemeProviderState>();
    }

    assert(
      state != null,
      'Context does not include a StateMixinProviderState.',
    );

    return state!.widget;
  }

  @override
  State<StateMixinThemeProvider> createState() =>
      StateMixinThemeProviderState();
}

class StateMixinThemeProviderState extends State<StateMixinThemeProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
