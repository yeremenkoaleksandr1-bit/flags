import 'package:flags/features/editor/editor/presentation/components/flag_style.dart';
import 'package:flags/features/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorBackgroundStyleView extends StatelessWidget {
  const EditorBackgroundStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundStyleCubit = context.read<EditorFlagBackgroundStyleCubit>();
    return BlocBuilder<EditorFlagBackgroundStyleCubit,
        EditorFlagBackgroundStyleState>(
      bloc: backgroundStyleCubit,
      builder: (
        BuildContext context,
        EditorFlagBackgroundStyleState state,
      ) {
        return FlagStyleView(
          style: state.style,
        );
      },
    );
  }
}
