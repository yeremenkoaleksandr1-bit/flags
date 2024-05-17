import 'package:flags/features/vibration/vibration.service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhoneVibrationProvider extends StatefulWidget {
  const PhoneVibrationProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static IPhoneVibrationController of(BuildContext context) {
    final instance = context.findAncestorStateOfType<_PhoneVibrationProvider>();
    assert(
      instance != null,
      "Cannot find IPhoneVibrationController in current context",
    );

    return instance!;
  }

  @override
  State<PhoneVibrationProvider> createState() => _PhoneVibrationProvider();
}

abstract interface class IPhoneVibrationController {
  ValueListenable<bool> get muted;

  Future<void> toggleMute();

  Future<void> vibrate({int milliseconds = 150});
}

class _PhoneVibrationProvider extends State<PhoneVibrationProvider>
    implements IPhoneVibrationController {
  final IPhoneVibrationService service = PhoneVibrationServiceImpl();

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  // TODO: implement muted
  ValueNotifier<bool> get muted => service.muted;

  @override
  Future<void> toggleMute() => service.toggleMute();

  @override
  Future<void> vibrate({int milliseconds = 150}) =>
      service.vibrate(milliseconds: milliseconds);

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }
}
