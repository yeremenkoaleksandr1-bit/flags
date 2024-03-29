import 'package:armar/armar.dart';
import 'package:flutter/material.dart';

class RenderBoxExposer {
  bool isExposed = false;

  RxValue<RenderBox?> renderBox = RxValue(null);
}

class RenderBoxExposed extends StatelessWidget {
  final Widget child;

  final RenderBoxExposer exposer;

  RenderBoxExposed({super.key, required this.child, required this.exposer});

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      exposer.isExposed = true;
      exposer.renderBox.value =
          _globalKey.currentContext!.findRenderObject()! as RenderBox;
    });

    return KeyedSubtree(
      key: _globalKey,
      child: child,
    );
  }
}
