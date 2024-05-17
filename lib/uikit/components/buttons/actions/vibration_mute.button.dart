import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/features/vibration/vibration.provider.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FVibrationMuteButton extends StatelessWidget {
  const FVibrationMuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = PhoneVibrationProvider.of(context);

    return FBlueButton(
      onPressed: audioService.toggleMute,
      child: ValueListenableBuilder(
        valueListenable: audioService.muted,
        builder: (BuildContext context, bool value, Widget? child) {
          return Icon(
            value
                ? CommunityMaterialIcons.vibrate_off
                : CommunityMaterialIcons.vibrate,
            color: ThemePalette.white,
          );
        },
      ),
    );
  }
}
