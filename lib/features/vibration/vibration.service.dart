import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/foundation.dart';
import 'package:state_manager/state_manager.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';

const String _phoneVibrationMuteKey = "33b783382f73";

abstract class IPhoneVibrationService implements IDisposable {
  ValueNotifier<bool> get muted;

  Future<void> toggleMute();

  Future<void> mediumImpact();

  Future<void> vibrate({int milliseconds = 150});
}

class PhoneVibrationServiceImpl implements IPhoneVibrationService {
  final Box<bool> _preferences = Hive.box(name: "preferences");

  @override
  late final ValueNotifier<bool> muted;

  bool get isMuted => muted.value;

  PhoneVibrationServiceImpl({
    bool initialMuted = false,
  }) {
    muted =
        ValueNotifier(_preferences.get(_phoneVibrationMuteKey) ?? initialMuted);
  }

  @override
  Future<void> toggleMute() async {
    muted.value = !isMuted;
    _preferences.put(_phoneVibrationMuteKey, isMuted);
  }

  @override
  Future<void> mediumImpact() async {
    if (isMuted) {
      return;
    }
    await HapticFeedback.mediumImpact();
  }

  @override
  Future<void> vibrate({int milliseconds = 150}) async {
    if (isMuted) {
      return;
    }
    try {
      await Vibration.vibrate(duration: milliseconds);
    } catch (e) {}
  }

  @override
  void dispose() {
    muted.dispose();
  }
}
