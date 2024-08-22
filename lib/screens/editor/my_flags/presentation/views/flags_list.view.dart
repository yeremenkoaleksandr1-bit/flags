import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/screens/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flags/shared/bloc/builder/state_builder.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../components/flag_preview.dart';

class FlagsListView extends StatefulWidget {
  const FlagsListView({super.key});

  @override
  State<FlagsListView> createState() => _FlagsListViewState();
}

class _FlagsListViewState extends State<FlagsListView> {
  Future<void> openFlagInEditor(EditorFlagData flag) async {
    await QR.toName(
      Routes.editFlag,
      params: {'data': flag.clone()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyFlagsCubit>();

    return BlocStateBuilder(
      listener: bloc,
      builder: (List<EditorFlagData> state) {
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
                        onTap: () => openFlagInEditor(e),
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
                onPressed: () {},
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
