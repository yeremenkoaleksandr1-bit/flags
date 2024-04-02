import 'dart:async';

import 'package:flags/core/flutter_engine.dart';
import 'package:flags/features/onboarding/onboarding.service.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PuzzleGameFastModeShowcase {
  final IOnboardingService _service = IOnboardingService.I;

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
      showcaseState.startShowCase(currentShowcases);
    });
  }

  ShowCaseWidgetState<ShowCaseWidget> get showcaseState =>
      ShowCaseWidget.of(key.currentContext!);
}
