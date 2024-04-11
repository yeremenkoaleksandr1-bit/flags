import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/presentation/presenters/my_flags/my_flags.presenter.dart';
import 'package:flags/screens/editor/my_flags/components/flag_preview.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlagsListView extends ArGetLocatorWidget<IMyFlagsPresenter> {
  const FlagsListView({super.key});

  @override
  Widget build(BuildContext context, IMyFlagsPresenter presenter) {
    return FCard(
      padding: const Pad(all: 4, bottom: 12),
      child: Column(
        children: [
          Expanded(
            child: FastValueBuilder(
              listen: presenter.flags,
              builder: (Iterable<EditorFlagData> value) {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  padding: EdgeInsets.zero,
                  children: [
                    ...value.map(
                      (e) => ScaledGestureDetector(
                        onTap: () => presenter.openFlag(e),
                        child: EditorFlagPreview(
                          flag: e,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Gap.v12,
          FGreenButton(
            onPressed: presenter.createFlag,
            child: Center(
              child: FText(
                "new flag",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
