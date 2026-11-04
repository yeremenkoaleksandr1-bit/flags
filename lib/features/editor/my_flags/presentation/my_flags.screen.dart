import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/annotations.dart';
import 'package:flags/features/editor/my_flags/presentation/views/flags_list.view.dart';

import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyFlagsScreen extends StatelessWidget {
  const MyFlagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameSafeArea(
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
    );
  }
}
