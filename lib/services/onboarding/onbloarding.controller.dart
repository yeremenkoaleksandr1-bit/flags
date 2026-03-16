import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

class OnboardingController {
  static const int _maxStartAttempts = 12;

  final IOnboardingService _service;
  final GlobalKey _showcaseKey;

  final List<GlobalKey> widgetsKeys;

  final String tag;

  OnboardingController({
    required this.tag,
    required GlobalKey showcaseKey,
    required this.widgetsKeys,
    required IOnboardingService service,
  }) : _service = service,
       _showcaseKey = showcaseKey;

  void show(BuildContext context) {
    if (!canShow) {
      return;
    }

    _startWhenReady(context, attempt: 0);
  }

  void hide() {}

  bool get canShow => !_service.isOnboarded(tag);

  void complete() {
    _service.complete(tag);
  }

  void _startWhenReady(BuildContext context, {required int attempt}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }

      final hasAllTargets = widgetsKeys.every(
        (key) => key.currentContext != null,
      );
      final state = _showcaseStateOrNull();

      if (state != null && state.isShowCaseCompleted && hasAllTargets) {
        state.startShowCase(widgetsKeys);
        return;
      }

      if (attempt >= _maxStartAttempts) {
        return;
      }

      _startWhenReady(context, attempt: attempt + 1);
    });
  }

  ShowCaseWidgetState<ShowCaseWidget>? _showcaseStateOrNull() {
    final state = _showcaseKey.currentState;
    if (state is ShowCaseWidgetState<ShowCaseWidget>) {
      return state;
    }

    return null;
  }
}
