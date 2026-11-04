import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/uikit/components/buttons/colors/green_button.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Окно «на этом флаге теперь можно поиграть в Flag games».
/// [flagName] — имя флага пазлов (GameFlag.name), по нему же и картинка игры.
Future<void> showFlagGameUnlockedDialog(BuildContext context, String flagName) {
  context.read<IAudioCubit>().playSfx(GameSfx.sectionCompleted);
  final image =
      'assets/images/flag_games/${flagName.toLowerCase()}/'
      '${flagName.toLowerCase()}_flag.png';
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    useSafeArea: false,
    builder: (ctx) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 22),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FText(
                'New flag game unlocked!',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 30, color: Colors.amber),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
              FText(
                'You can now play the flag of $flagName\nin Flag games!',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 22),
              FGreenButton(
                onPressed: () => Navigator.of(ctx).pop(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: FText('Cool!', textStyle: const TextStyle(fontSize: 26)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
