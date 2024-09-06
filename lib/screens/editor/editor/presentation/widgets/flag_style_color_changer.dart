import 'package:flags/screens/editor/editor/presentation/cubits/flag_background_style/flag_background_style_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/dialogs/color_picker/color_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlagStyleColorChanger extends StatelessWidget {
  const FlagStyleColorChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundStyleCubit = context.read<EditorFlagBackgroundStyleCubit>();

    Future<void> onChangeColor(int index, Color value) async {
      final newColor = await showColorPickerDialog(context, value);

      if (newColor != null) {
        backgroundStyleCubit.changeColor(index, newColor);
      }
    }

    return BlocBuilder<EditorFlagBackgroundStyleCubit,
        EditorFlagBackgroundStyleState>(
      bloc: backgroundStyleCubit,
      builder: (
        BuildContext context,
        EditorFlagBackgroundStyleState state,
      ) {
        return AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 150,
          ),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...state.style.colors.indexed.map((e) {
                return GestureDetector(
                  onTap: () => onChangeColor(e.$1, e.$2),
                  child: _ColorView(e.$2),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ColorView extends StatelessWidget {
  const _ColorView(
    this.color, {
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: const SizedBox.square(
        dimension: 32,
      ),
    );
  }
}
