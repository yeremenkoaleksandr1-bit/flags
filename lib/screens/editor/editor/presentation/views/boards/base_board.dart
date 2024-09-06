import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditorBaseBoard extends StatefulWidget {
  const EditorBaseBoard({super.key, required this.buildWhen});

  final bool Function(
    FlagEditorState previous,
    FlagEditorState current,
  ) buildWhen;

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

    return BlocBuilder<IFlagEditorCubit, FlagEditorState>(
      buildWhen: widget.buildWhen,
      builder: (
        BuildContext context,
        FlagEditorState state,
      ) {
        Widget child = const SizedBox();

        if (widget.getState(state)) {
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
          duration: const Duration(milliseconds: 150),
          child: child,
        );
      },
    );
  }
}
