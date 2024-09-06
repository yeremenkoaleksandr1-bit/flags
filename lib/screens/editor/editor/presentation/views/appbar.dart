import 'package:flags/features/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/flag_editor_cubit.dart';

class EditorAppBarView extends StatelessWidget {
  const EditorAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();

    return Row(
      children: [
        FBackButton(
          onPressed: () {},
        ),
        Gap.h24,
        Expanded(
          child: FText(bloc.initialFlag.name),
        ),
        const TotalMoneysView(
          widgetKey: ValueKey("total_moneys"),
        ),
      ],
    );
  }
}
