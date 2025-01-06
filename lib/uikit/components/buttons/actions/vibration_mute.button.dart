import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/audio/presentation/builder/audio_state_builder.dart';
import 'package:flags/features/app/features/vibration/presentation/builder/vibration_state_builder.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FVibrationMuteButton extends StatelessWidget {
  const FVibrationMuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCubit = context.read<IAudioCubit>();

    return FBlueButton(
      onPressed: audioCubit.toggleMute,
      child: BuildAudioPreferences(
        builder: (BuildContext context, AudioState state) {
          return Icon(
            state.muted
                ? CommunityMaterialIcons.vibrate_off
                : CommunityMaterialIcons.vibrate,
            color: ThemePalette.white,
          );
        },
      ),
    );
  }
}
