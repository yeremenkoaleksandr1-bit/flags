import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/logger.dart';
import 'package:flags/screens/editor/my_flags/presentation/views/flags_list.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class MyFlagsScreen extends StatelessWidget {
  const MyFlagsScreen({super.key});

  static Future<void> show(BuildContext context) async => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyFlagsScreen(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GameSafeArea(
      child: GamePageBuilder(
        onPageFocussed: () {
          logger.i("focucessedsdadsd");
        },
        onPageUnfocused: () {
          logger.i("unfoc");
        },
        startSlideDirection: GamePageSlideDirection.bottom,
        endSlideDirection: GamePageSlideDirection.bottom,
        child: Column(
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
    );
  }
}
