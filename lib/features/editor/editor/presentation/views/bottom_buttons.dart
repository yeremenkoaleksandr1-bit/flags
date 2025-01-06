import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorBottomButtonsView extends StatelessWidget {
  const EditorBottomButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();
    return Row(
      children: [
        Expanded(
          child: FGreenButton(
            onPressed: () {
              bloc.toggleStylesBoardOpen(true);
            },
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("styles")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {
              bloc.toggleShapesBoardOpen(true);
            },
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("shapes")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {
              bloc.toggleEmblemsBoardOpen(true);
            },
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("emblems")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {
              bloc.toggleCustomPaintBoardOpen(true);
            },
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("custom")),
            ),
          ),
        ),
      ],
    );
  }
}
