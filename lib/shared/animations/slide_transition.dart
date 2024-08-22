import 'package:flutter/material.dart';

Widget slideTransitionBuilder(
  Widget child,
  Animation<double> animation,
) {
  const offset = Offset(0.0, 0.02);
  final slideTransition = SlideTransition(
    position: Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
  return FadeTransition(
    opacity: animation,
    child: slideTransition,
  );
}
