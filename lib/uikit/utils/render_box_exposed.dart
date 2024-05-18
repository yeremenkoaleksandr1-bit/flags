import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/material.dart';

class RenderBoxExposer implements IDisposable {
  bool isExposed = false;

  ValueNotifier<RenderBox?> renderBox = ValueNotifier(null);

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
      widget.exposer.renderBox.value =
          _globalKey.currentContext!.findRenderObject()! as RenderBox;
      widget.exposer.renderBox.notifyListeners();
    });

    return KeyedSubtree(
      key: _globalKey,
      child: widget.child,
    );
  }
}
