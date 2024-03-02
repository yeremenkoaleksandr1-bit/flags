import 'package:armar/components/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';

class ArDrawerBuilder extends StatelessWidget {
  const ArDrawerBuilder({
    super.key,
    required this.drawer,
    required this.child,
  });

  final Widget drawer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        drawer,
      ],
    );
  }
}
