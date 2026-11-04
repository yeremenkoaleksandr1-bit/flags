import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flags/shared/data/local/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppBootstrap {
  AppBootstrap._({
    required this.sharedPreferences,
    required this.secureStorage,
    required this.onboardingService,
  });

  final SharedPreferences sharedPreferences;
  final SecureStorageServiceImpl secureStorage;
  final IOnboardingService onboardingService;

  static Future<AppBootstrap> initialize() async {
    final secureStorage = SecureStorageServiceImpl();
    await secureStorage.init();

    final sharedPreferences = await SharedPreferences.getInstance();

    return AppBootstrap._(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
      onboardingService: OnboardingServiceImpl(
        prefs: sharedPreferences,
      ),
    );
  }
}
