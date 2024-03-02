import 'dart:math';

import 'package:armar/armar.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../uikit/components/buttons/colors/green_button.dart';
import '../../../../../uikit/layout_components/gap/gap.dart';
import '../../scene_components/emblem.dart';
import 'base.dart';

class EmblemEditingBoard extends ProcessObjectEditingBoard {
  const EmblemEditingBoard({
    super.key,
    required super.presenter,
  });

  @override
  State<EmblemEditingBoard> createState() => _EmblemEditingBoardState();
}

class _EmblemEditingBoardState extends ProcessObjectEditingBoardState<
    EmblemEditingBoard, EmblemSceneObjectState> {
  void rotate(bool direction) {
    late final object =
        widget.presenter.focusedObject.value! as EmblemSceneObjectState;

    var rotation = (object.rotationRx.value + (pi / 4) * (direction ? 1 : -1))
        .remainder(pi * 2);
    if (rotation < 0) rotation += pi * 2;

    object.rotationRx.value = rotation;
  }

  @override
  Widget buildWidget(
    BuildContext context,
    EmblemSceneObjectState? focussedObject,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: ThemePalette.black,
            inactiveTrackColor: ThemePalette.peach.darken(0.2),
            trackHeight: 12.0,
            thumbColor: ThemePalette.black,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayColor: ThemePalette.white,
          ),
          child: FastBuilder(
            () {
              if (widget.presenter.focusedObject.value
                  is! EmblemSceneObjectState) {
                return const SizedBox.shrink();
              }

              late final object = widget.presenter.focusedObject.value
                  as EmblemSceneObjectState?;

              final scale = (object?.scaleRx.value ?? 0).roundToDouble();

              return Slider(
                value: scale,
                divisions: 3,
                max: 3,
                onChanged: (v) {
                  object?.scaleRx.value = v;
                },
              );
            },
          ),
        ),
        Gap.v12,
        Row(
          children: [
            const Spacer(),
            FGreenButton(
              onPressed: () => rotate(false),
              child: const Icon(
                Icons.rotate_90_degrees_ccw_sharp,
                size: 64,
                color: Colors.white,
              ),
            ),
            Gap.h24,
            FGreenButton(
              onPressed: () => rotate(true),
              child: const Icon(
                Icons.rotate_90_degrees_cw_outlined,
                size: 64,
                color: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
