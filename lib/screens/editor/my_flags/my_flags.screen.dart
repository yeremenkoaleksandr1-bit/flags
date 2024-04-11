import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/presentation/presenters/my_flags/my_flags.presenter.dart';
import 'package:flags/screens/editor/my_flags/views/flags_list.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFlagsScreen extends ArGetScreen<IMyFlagsPresenter> {
  const MyFlagsScreen({super.key, required super.presenter});

  @override
  Widget build(BuildContext context, IMyFlagsPresenter presenter) {
    return GameSafeArea(
      child: GamePageBuilder(
        startSlideDirection: GamePageSlideDirection.bottom,
        endSlideDirection: GamePageSlideDirection.bottom,
        child: presenter.obx(
          (state) => Column(
            children: [
              Padding(
                padding: const Pad(horizontal: 8),
                child: Row(
                  children: [
                    const FBackButton(),
                    Gap.h24,
                    FText("Flag gallery"),
                  ],
                ),
              ),
              Gap.v12,
              const Expanded(
                child: FlagsListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
