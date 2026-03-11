import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

class OnboardingController {
  final IOnboardingService _service;

  final List<GlobalKey> widgetsKeys;

  final String tag;

  OnboardingController({
    required this.tag,
    required this.widgetsKeys,
    required IOnboardingService service,
  }) : _service = service;

  void show(BuildContext context) {
    if (!canShow) {
      return;
    }
    ShowCaseWidget.of(context).startShowCase(widgetsKeys);
  }

  void hide() {}

  bool get canShow => !_service.isOnboarded(tag);

  void complete() {
    _service.complete(tag);
  }
}
