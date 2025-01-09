import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditorBaseBoard extends StatefulWidget {
  const EditorBaseBoard({
    super.key,
  });

  Positioned buildWidget(
    BuildContext context,
    BoxConstraints constraints,
  );

  void onBackgroundTapped(IFlagEditorCubit bloc);

  bool getState(FlagEditorState state);

  @override
  State<EditorBaseBoard> createState() => _EditorBaseBoardState();
}

class _EditorBaseBoardState extends State<EditorBaseBoard> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();

    return BlocDynamicStateBuilder.onlySuccess(
      bloc: bloc,
      builder: (BuildContext context, FlagEditorState state) {
        Widget child;
        if (!widget.getState(state)) {
          child = const SizedBox.shrink();
        } else {
          child = LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => widget.onBackgroundTapped(bloc),
                      child: const Material(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  widget.buildWidget(context, constraints),
                ],
              );
            },
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: child,
        );
      },
    );
  }
}
