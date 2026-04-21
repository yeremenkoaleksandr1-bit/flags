import 'package:auto_route/auto_route.dart';
import 'package:flags/features/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/features/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flags/logger.dart';
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
    final sceneObject = context.read<EditorSceneObjectsCubit>();
    final styleCubit = context.read<EditorFlagBackgroundStyleCubit>();

    Future<void> onBack() async {
      await EasyLoading.show();
      try {
        final flag = await bloc.saveFlag(
          objects: sceneObject.state.objects,
          style: styleCubit.state.style,
        );

        if (flag != null) {
          context.read<MyFlagsCubit>().updateFlag(flag);
          Navigator.of(context).pop();
        }
      } catch (e) {}

      await EasyLoading.dismiss();
    }

    return Row(
      children: [
        FBackButton(
          onPressed: onBack,
        ),
        Gap.h24,
        Expanded(
          child: FText(bloc.initialFlag.name, maxLines: 1, ),
        ),
        const TotalMoneysView(
          widgetKey: ValueKey("total_moneys"),
        ),
      ],
    );
  }
}
