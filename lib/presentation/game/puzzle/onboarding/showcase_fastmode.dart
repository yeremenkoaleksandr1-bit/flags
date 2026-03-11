import 'dart:async';

import 'package:flags/core/flutter_engine.dart';
import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PuzzleGameFastModeShowcase {
  PuzzleGameFastModeShowcase({
    required IOnboardingService service,
  }) : _service = service;

  final IOnboardingService _service;

  final GlobalKey key = GlobalKey();

  final GlobalKey step1 = GlobalKey();
  final GlobalKey step2 = GlobalKey();

  Completer? completeFuture;

  void complete(String tag) => _service.complete(tag);

  bool isCompleted(String tag) => _service.isOnboarded(tag);

  void show(List<GlobalKey> currentShowcases, String tag) {
    if (isCompleted(tag)) {
      return;
    }

    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      final state = showcaseStateOrNull;
      if (state == null || !state.isShowCaseCompleted) {
        return;
      }

      state.startShowCase(currentShowcases);
    });
  }

  void next() {
    final state = showcaseStateOrNull;
    if (state == null) {
      return;
    }

    state.next();
  }

  void dismiss() {
    final state = showcaseStateOrNull;
    if (state == null) {
      return;
    }

    state.dismiss();
  }

  ShowCaseWidgetState<ShowCaseWidget>? get showcaseStateOrNull {
    final context = key.currentContext;

    if (context == null || !context.mounted) {
      return null;
    }

    try {
      return ShowCaseWidget.of(context);
    } catch (_) {
      return null;
    }
  }

  ShowCaseWidgetState<ShowCaseWidget> get showcaseState =>
      showcaseStateOrNull!;
}
