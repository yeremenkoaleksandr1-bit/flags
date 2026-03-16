import 'package:auto_route/annotations.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/games/presentation/puzzle/common.dart';
import 'package:flags/features/games/presentation/puzzle/fastmode.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesFactoryPageParams {
  final GameLevel level;

  final GameProcessType gameMode;
  final GameDifficult difficult;
  final ContinentType continentType;
  final GameStyleType gamesType;

  GamesFactoryPageParams({
    required this.level,
    required this.gameMode,
    required this.difficult,
    required this.continentType,
    required this.gamesType,
  });
}

@RoutePage()
class GamesFactoryPage extends StatefulWidget {
  const GamesFactoryPage({super.key, required this.params});

  final GamesFactoryPageParams params;

  @override
  State<GamesFactoryPage> createState() => _GamesFactoryPageState();
}

class _GamesFactoryPageState extends State<GamesFactoryPage>
    with TickerProviderStateMixin {
  late Widget screen;

  bool _isReady = false;

  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  @override
  void initState() {
    final params = widget.params;
    final onboardingService = AppScope.readBootstrapOf(
      context,
    ).onboardingService;

    screen = switch (params.gamesType) {
      GameStyleType.common => PuzzleCommonModeView(
        cubit: PuzzleCommonModeCubit(
          context,
          this,
          params: params,
          appCubit: context.read<IAppCubit>(),
          levelsCubit: context.read<ILevelsPickerCubit>(),
          onboardingService: onboardingService,
        ),
      ),
      GameStyleType.fast => PuzzleFastModeView(
        cubit: PuzzleFastModeCubit(
          context,
          this,
          params: params,
          appCubit: context.read<IAppCubit>(),
          levelsCubit: context.read<ILevelsPickerCubit>(),
          onboardingService: onboardingService,
        ),
      ),
    };

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onPageFocussed() {
      if (widget.params.gamesType == GameStyleType.fast) {
        audioCubit.playBgm(GameMusics.fastMode);
      }
    }

    return DeferredPointerHandler(
      child: GamePageBuilder(
        startSlideDirection: GamePageSlideDirection.middle,
        endSlideDirection: GamePageSlideDirection.bottom,
        onPageFocussed: onPageFocussed,
        child: Builder(
          builder: (BuildContext context) {
            if (_isReady) {
              return screen;
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
