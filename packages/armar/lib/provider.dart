import 'package:flutter/material.dart';

import 'contexts/contexts.dart';

class ArmarProvider extends StatefulWidget {
  const ArmarProvider({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context) builder;

  static IArmarProvider providerOf<T>(BuildContext context) {
    IArmarProvider? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<ArmarProviderState>();
    }
    assert(state != null, 'Context does not include a ArmarProviderState.');

    return state!;
  }

  @override
  State<ArmarProvider> createState() => ArmarProviderState();
}

abstract interface class IArmarProvider {

}

class ArmarProviderState extends State<ArmarProvider>
    implements IArmarProvider {


  @override
  Widget build(BuildContext context) => widget.builder(context);
}

extension ArmarProviderContextExtensions on BuildContext {
  IArmarProvider get arProvider => ArmarProvider.providerOf(this);
}
