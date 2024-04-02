import 'package:flags/core/flutter_engine.dart';
import 'package:flags/features/onboarding/onboarding.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

class OnboardingController {
  final IOnboardingService _service = IOnboardingService.I;

  final List<GlobalKey> widgetsKeys;

  final String tag;

  OnboardingController({
    required this.tag,
    required this.widgetsKeys,
  });

  void show(BuildContext context) {
    if (!canShow) {
      return;
    }
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context).startShowCase(widgetsKeys);
    });
  }

  void hide() {}

  bool get canShow => !_service.isOnboarded(tag);

  void complete() {
    _service.complete(tag);
  }
}
