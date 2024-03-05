import 'package:armar/armar.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../presentation/navigator/routes.dart';
import '../../presentation/presentation.dart';
import '../../ui/game_scaffold.dart';
import '../../uikit/assets/assets.dart';
import '../../uikit/uikit.dart';

class HomeScreen extends ArGetScreen<IHomePresenter> {
  const HomeScreen({
    super.key,
    required super.presenter,
  }) : super(tag: "single");

  void openGamePickerPage() {
    QR.toName(Routes.gameModePicker);
  }

  void openMyFlagsPage() {
    QR.toName(Routes.myFlags);
  }

  @override
  Widget build(BuildContext context, IHomePresenter presenter) {
    return SafeArea(
      child: GameTransitionPageBuilder(
        startSlideDirection: GamePageSlideDirection.middle,
        endSlideDirection: GamePageSlideDirection.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SpriteUIWidget(image: Assets.images.logo.image),
              const Spacer(),
              FYellowButton(
                onPressed: openGamePickerPage,
                child: Center(
                  child: FText("PLAY"),
                ),
              ),
              Gap.v12,
              FYellowButton(
                onPressed: openMyFlagsPage,
                child: Center(
                  child: FText("MY FLAGS"),
                ),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
