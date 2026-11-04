import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildAudioPreferences extends StatelessWidget {
  const BuildAudioPreferences({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final Widget Function(BuildContext context, AudioState state) builder;

  final bool Function(AudioState previous, AudioState current)? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IAudioCubit, AudioState>(
      bloc: context.read<IAudioCubit>(),
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
