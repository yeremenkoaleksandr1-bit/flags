import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PuzzleGameShowcase {
  static const int _maxStartAttempts = 12;

  PuzzleGameShowcase({required IOnboardingService service})
    : _service = service;

  final IOnboardingService _service;

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

    _startWhenReady(currentShowcases, attempt: 0);
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
    final state = key.currentState;
    if (state is ShowCaseWidgetState<ShowCaseWidget>) {
      return state;
    }

    return null;
  }

  ShowCaseWidgetState<ShowCaseWidget> get showcaseState => showcaseStateOrNull!;

  void _startWhenReady(
    List<GlobalKey> currentShowcases, {
    required int attempt,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = showcaseStateOrNull;
      final hasAllTargets = currentShowcases.every(
        (key) => key.currentContext != null,
      );

      if (state != null && state.isShowCaseCompleted && hasAllTargets) {
        state.startShowCase(currentShowcases);
        return;
      }

      if (attempt >= _maxStartAttempts) {
        return;
      }

      _startWhenReady(currentShowcases, attempt: attempt + 1);
    });
  }
}
