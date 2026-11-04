import 'package:flags/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IOnboardingService {
  bool isOnboarded(String tag);

  void complete(String tag);
}

class OnboardingServiceImpl implements IOnboardingService {
  final SharedPreferences _prefs;

  OnboardingServiceImpl({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  @override
  bool isOnboarded(String tag) {
    return _prefs.getBool('onboarding.$tag') ?? false;
  }

  @override
  void complete(String tag) {
    logger.d(tag);
    _prefs.setBool('onboarding.$tag', true);
  }
}
