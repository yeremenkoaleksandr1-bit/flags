import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/features/levels_picker/presentation/screen/levels_picker_screen_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LevelsPickerScreen extends StatelessWidget {
  const LevelsPickerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GamePageBuilder(
      // своя зацикленная музыка у каждого континента
      onPageFocussed: () => context.read<IAudioCubit>().playBgm(
        continentMusic(context.read<ILevelsPickerCubit>().continentType),
      ),
      curve: Curves.easeInQuad,
      startSlideDirection: GamePageSlideDirection.bottom,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: const GameSafeArea(
        child: LevelsPickerScreenView(),
      ),
    );
  }
}
