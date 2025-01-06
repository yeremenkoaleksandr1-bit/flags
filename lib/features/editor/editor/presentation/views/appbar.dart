import 'package:flags/services/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../bloc/flag_editor_cubit.dart';

class EditorAppBarView extends StatelessWidget {
  const EditorAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();

    Future<void> onBack() async {
      await EasyLoading.show();
      final flag = await bloc.saveFlag();

      if (flag != null) {
        Navigator.of(context).pop(flag);
      }
      await EasyLoading.dismiss();
    }

    return Row(
      children: [
        FBackButton(
          onPressed: onBack,
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
