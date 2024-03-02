import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:widget_finder/widget_finder.dart';

import '../../armar.dart';
import '../../logger.dart';

mixin ScreenScrollControllerMixin {
  final ScrollController screenScrollController = ScrollController();

  final HashMap<Key, double> _hash = HashMap();

  Future<void> scrollUp({
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.linear,
  }) =>
      scrollToPosition(
        0,
        duration: duration,
        curve: curve,
      );

  Future<void> scrollToWidget(
    GlobalKey key, {
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.linear,
  }) async {
    assert(key.currentContext != null);

    double dy = 0;

    if (_hash.containsKey(key)) {
      dy = _hash[key]!;
      logger.w("test");
    } else {
      dy = WidgetFinder.of(key).topLeft.dy;
      _hash[key] = dy;
    }

    dy = WidgetFinder.of(key).topLeft.dy;
    _hash[key] = dy;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await scrollToPosition(
        dy,
        duration: duration,
        curve: curve,
      );
    });
  }

  Future<void> scrollToPosition(
    double dy, {
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.linear,
  }) =>
      screenScrollController.animateTo(
        dy,
        duration: duration,
        curve: curve,
      );

  void disposeScrollController() {
    screenScrollController.dispose();
  }
}
