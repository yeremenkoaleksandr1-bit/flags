import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/features/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flags/features/editor/my_flags/presentation/dialogs/actions.dialog.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/flag_preview.dart';

class FlagsListView extends StatefulWidget {
  const FlagsListView({super.key});

  @override
  State<FlagsListView> createState() => _FlagsListViewState();
}

class _FlagsListViewState extends State<FlagsListView> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyFlagsCubit>();

    return BlocDynamicStateBuilder(
      bloc: bloc,
      buildWhen: (p, c) => p.hashCode != c.hashCode,
      builder: (BuildContext context, List<EditorFlagData> state) {
        return FCard(
          padding: const Pad(all: 4, bottom: 12),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  padding: EdgeInsets.zero,
                  children: [
                    ...state.map(
                      (e) => ScaledGestureDetector(
                        onTap: () => bloc.openFlagInEditor(context, e),
                        onLongPress: () {
                          showDialogSuper(
                            context: context,
                            useSafeArea: false,
                            builder: (BuildContext context) {
                              return ActionsFlagDialog(
                                flag: e,
                                cubit: bloc,
                              );
                            },
                          );
                        },
                        child: EditorFlagPreview(
                          flag: e,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap.v12,
              FGreenButton(
                onPressed: () => bloc.createFlag(context),
                child: Center(
                  child: FText(
                    "new flag",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
