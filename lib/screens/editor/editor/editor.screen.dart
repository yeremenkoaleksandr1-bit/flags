import 'package:state_manager/state_manager.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/features/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/screens/editor/editor/views/boards/emblems_board.dart';
import 'package:flags/screens/editor/editor/views/boards/shapes_board.dart';
import 'package:flags/screens/editor/editor/views/boards/styles_board.dart';
import 'package:flags/screens/editor/editor/views/bottom_buttons.dart';
import 'package:flags/screens/editor/editor/views/editor_area.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditorScreen extends GetScreen<IEditorPresenter> {
  const EditorScreen({super.key, required super.controller});

  @override
  Widget build(BuildContext context, IEditorPresenter presenter) {
    return GamePageBuilder(
      startSlideDirection: GamePageSlideDirection.bottom,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: presenter.obx(
        (state) => Stack(
          children: [
            Positioned.fill(
              child: GameSafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const Pad(horizontal: 8),
                      child: Row(
                        children: [
                          const FBackButton(),
                          Gap.h24,
                          Expanded(child: FText(presenter.flag.name)),
                          const TotalMoneysView(
                            widgetKey: ValueKey("total_moneys"),
                          ),
                        ],
                      ),
                    ),
                    Gap.v12,
                    const Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: Pad(horizontal: 4),
                                child: EditorAreaView(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: EditorBottomButtonsView(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const EditorShapesBoard(),
            const EditorStylesBoard(),
            const EditorEmblemsBoard(),
          ],
        ),
      ),
    );
  }
}
