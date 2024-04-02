import 'package:armar/logger.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/features/onboarding/onboarding.service.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PuzzleGameShowcase {
  final IOnboardingService _service = IOnboardingService.I;

  final GlobalKey key = GlobalKey();

  final GlobalKey showcaseCommonObject = GlobalKey();

  final GlobalKey emblemObjectStep1 = GlobalKey();
  final GlobalKey emblemObjectStep2 = GlobalKey();

  final GlobalKey coloredObjectStep1 = GlobalKey();
  final GlobalKey coloredObjectStep2 = GlobalKey();

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
