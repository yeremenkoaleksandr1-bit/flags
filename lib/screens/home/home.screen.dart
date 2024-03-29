import 'package:armar/armar.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presentation.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
    return GameSafeArea(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Debug mode"),
                  StreamBuilder(
                    stream: IAppPresenter.I.appPreferences.box.watch(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return Switch(
                        activeTrackColor: ThemePalette.red,
                        trackOutlineColor:
                            MaterialStateProperty.all(Colors.transparent),
                        value: IAppPresenter.I.appPreferences.data.isDebugMode,
                        onChanged: (value) {
                          IAppPresenter.I.appPreferences.setDebugMode(value);
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
