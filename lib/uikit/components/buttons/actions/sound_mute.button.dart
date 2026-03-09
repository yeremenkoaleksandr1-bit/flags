import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/audio/presentation/builder/audio_state_builder.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FSoundMuteButton extends StatelessWidget {
  const FSoundMuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IAudioCubit>();

    return FBlueButton(
      onPressed: cubit.toggleMute,
      enableHapticFeedback: false,
      enableSoundFeedback: false,
      child: BuildAudioPreferences(
        builder: (BuildContext context, AudioState state) {
          return Icon(
            state.muted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
            color: ThemePalette.white,
          );
        },
      ),
    );
  }
}
