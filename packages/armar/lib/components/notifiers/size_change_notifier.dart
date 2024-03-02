import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_finder/widget_finder.dart';

import '../../logger.dart';

class ArSizeChangeNotifier extends StatefulWidget {
  const ArSizeChangeNotifier({super.key, required this.child});

  final Widget child;

  static IArSizeChangeNotifier? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_ArSizeChangeNotifierState>();
  }

  @override
  State<ArSizeChangeNotifier> createState() => _ArSizeChangeNotifierState();
}

abstract interface class IArSizeChangeNotifier {
  ValueListenable<Size> get notifier;
}

class _ArSizeChangeNotifierState extends State<ArSizeChangeNotifier>
    implements IArSizeChangeNotifier {
  final GlobalKey _key = GlobalKey();

  ValueNotifier<Size> onSizeChanged = ValueNotifier(Size.zero);

  @override
  ValueListenable<Size> get notifier => onSizeChanged;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logger.f("qweqqweqweqwe");
      onSizeChanged.value = WidgetFinder.of(_key).size;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    onSizeChanged.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Builder(
        key: _key,
        builder: (context) {
          logger.d('1');
          return widget.child;
        },
      );
}
