import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/features/levels_picker/presentation/screen/levels_picker_screen_view.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LevelsPickerScreen extends StatelessWidget {
  const LevelsPickerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const GamePageBuilder(
      curve: Curves.easeInQuad,
      startSlideDirection: GamePageSlideDirection.bottom,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: GameSafeArea(
        child: LevelsPickerScreenView(),
      ),
    );
  }
}
