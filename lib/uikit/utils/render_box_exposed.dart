import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/material.dart';

class RenderBoxNotifier extends ValueNotifier<RenderBox?> {
  RenderBoxNotifier() : super(null);

  void update(RenderBox nextRenderBox) {
    value = nextRenderBox;
    notifyListeners();
  }
}

class RenderBoxExposer implements IDisposable {
  bool isExposed = false;

  RenderBoxNotifier renderBox = RenderBoxNotifier();

  @override
  void dispose() {
    renderBox.dispose();
  }
}

class RenderBoxExposed extends StatefulWidget {
  final Widget child;

  final RenderBoxExposer exposer;

  const RenderBoxExposed({
    super.key,
    required this.child,
    required this.exposer,
  });

  @override
  State<RenderBoxExposed> createState() => _RenderBoxExposedState();
}

class _RenderBoxExposedState extends State<RenderBoxExposed> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.exposer.isExposed = true;
      widget.exposer.renderBox.update(
        _globalKey.currentContext!.findRenderObject()! as RenderBox,
      );
    });

    return KeyedSubtree(
      key: _globalKey,
      child: widget.child,
    );
  }
}
