import 'package:flags/getIt.dart';
import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PuzzleGameShowcase {
  final IOnboardingService _service = getIt<IOnboardingService>();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = showcaseStateOrNull;
      if (state == null || state.isShowCaseCompleted == false) {
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
