import 'package:flags/features/editor/editor/presentation/cubits/boards/custom_paint/custom_paint_cubit.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ActionsBoard extends StatelessWidget {
  const ActionsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomPaintCubit>();

    return FCard(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          buildChangeStrokeWidth(cubit),
          Gap.v24,
          buildColorPicker(cubit),
        ],
      ),
    );
  }

  Widget buildColorPicker(CustomPaintCubit cubit) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<CustomPaintCubit, CustomPaintState>(
          buildWhen: (p, c) => p.currentPaint.color != c.currentPaint.color,
          builder: (BuildContext context, CustomPaintState state) {
            final color = state.currentPaint.color;

            return Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth / 2.5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ColorPickerArea(
                      HSVColor.fromColor(color),
                      (v) {
                        cubit.changeColor(v.toColor());
                      },
                      PaletteType.hsv,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ColorPickerSlider(
                      TrackType.hue,
                      HSVColor.fromColor(color),
                      (v) {
                        cubit.changeColor(v.toColor());
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  BlocBuilder<CustomPaintCubit, CustomPaintState> buildChangeStrokeWidth(
    CustomPaintCubit cubit,
  ) {
    return BlocBuilder<CustomPaintCubit, CustomPaintState>(
      buildWhen: (p, c) =>
          p.currentPaint.strokeWidth != c.currentPaint.strokeWidth ||
          p.currentPaint.color != c.currentPaint.color,
      builder: (BuildContext context, CustomPaintState state) {
        return Row(
          children: [
            SizedBox.square(
              dimension: 24,
              child: Center(
                child: Material(
                  shape: const CircleBorder(),
                  color: state.currentPaint.color,
                  child: SizedBox.square(
                    dimension: state.currentPaint.strokeWidth,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Slider(
                value: state.currentPaint.strokeWidth,
                max: 24,
                divisions: 24,
                min: 1,
                onChanged: cubit.changeWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}
