import 'package:state_manager/state_manager.dart';
import 'package:hive/hive.dart';

abstract interface class IOnboardingService {
  static IOnboardingService get I => Get.find<IOnboardingService>();

  bool isOnboarded(String tag);

  void complete(String tag);
}

class OnboardingServiceImpl implements IOnboardingService {
  final Box<bool> box = Hive.box(name: "onboarding");

  // OnboardingServiceImpl() {
  //   box.clear();
  // }

  @override
  bool isOnboarded(String tag) {
    return box.containsKey(tag);
  }

  @override
  void complete(String tag) {
    box.put(tag, true);
  }
}
