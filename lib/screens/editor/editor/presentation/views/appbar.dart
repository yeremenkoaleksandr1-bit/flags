import 'package:flags/features/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_bloc.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorAppBarView extends StatelessWidget {
  const EditorAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FlagEditorBloc>();

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
