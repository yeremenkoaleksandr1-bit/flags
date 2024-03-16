import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/screens/games/base/game_process_screen.dart';
import 'package:flags/screens/games/puzzle/common.dart';
import 'package:flags/screens/games/puzzle/fastmode.dart';
import 'package:flags/uikit/layout_components/overlayment/overlayment.provider.dart';
import 'package:flutter/material.dart';

import '../../presentation/app/app.presenter.dart';
import '../../ui/game_scaffold.dart';

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

class GamesFactoryPage extends StatefulWidget {
  const GamesFactoryPage({
    super.key,
    required this.params,
  });

  final GamesFactoryPageParams params;

  @override
  State<GamesFactoryPage> createState() => _GamesFactoryPageState();
}

class _GamesFactoryPageState extends State<GamesFactoryPage> {
  late GameProcessScreen screen;

  bool _isReady = false;

  @override
  void initState() {
    final params = widget.params;

    screen = switch (params.gameMode) {
      GameProcessType.puzzle => switch (params.gamesType) {
          GameStyleType.common => PuzzleCommonMode(
              presenter: (_) =>
                  PuzzleCommonModePresenterImpl(context, params: params),
            ),
          GameStyleType.fast => PuzzleFastMode(
              presenter: (_) =>
                  PuzzleFastModePresenterImpl(context, params: params),
            ),
        },
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
    return GameTransitionPageBuilder(
      startSlideDirection: GamePageSlideDirection.middle,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: BackButtonListener(
        onBackButtonPressed: () async {
          return !IAppPresenter.isDebugMode;
        },
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
