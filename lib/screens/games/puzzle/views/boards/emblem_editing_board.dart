import 'dart:math';

import 'package:armar/armar.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/presentation/game/puzzle/onboarding/emblem/emblem_object.showcase_step_2.dart';
import 'package:flags/screens/games/puzzle/scene_components/emblem.dart';
import 'package:flags/screens/games/puzzle/views/boards/base.dart';
import 'package:flags/uikit/components/buttons/colors/green_button.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

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
  final RxValue<double> _scale = RxValue(0.0);

  late final RxValue _focusedObject = widget.presenter.focusedObject;

  @override
  void initState() {
    _focusedObject.stream.listen(_listen);

    super.initState();
  }

  void _listen(event) {
    if (event is EmblemSceneObjectState) {
      _scale.run(() {
        _scale.value = event.gameObject.scales
            .indexWhere(
              (e) => e.roundDouble(1) == event.scaleRx.value.roundDouble(1),
            )
            .toDouble();

        if (_scale.value == -1) {
          _scale.value = 0;
        }
      });
    }
  }

  void rotate(bool direction) {
    late final object = _focusedObject.value! as EmblemSceneObjectState;

    var rotation = (object.rotationRx.value + (pi / 4) * (direction ? 1 : -1))
        .remainder(pi * 2);
    if (rotation < 0) {
      rotation += pi * 2;
    }

    object.rotationRx.value = rotation;
  }

  @override
  Widget buildWidget(
    BuildContext context,
    EmblemSceneObjectState? focussedObject,
  ) {
    return PuzzleEmblemObjectStep2Showcase(
      showcaseKey: widget.presenter.showcase.emblemObjectStep2,
      onTap: () {
        widget.presenter.showcase.complete("puzzle_emblem_object");
        widget.presenter.showcase.showcaseState.next();
      },
      child: DeferPointer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: ThemePalette.black,
                inactiveTrackColor: ThemePalette.peach.darken(0.2),
                trackHeight: 12.0,
                thumbColor: ThemePalette.black,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: ThemePalette.white,
              ),
              child: FastBuilder(
                () {
                  if (_focusedObject.value is! EmblemSceneObjectState) {
                    return const SizedBox.shrink();
                  }

                  late final object =
                      _focusedObject.value as EmblemSceneObjectState?;

                  return Slider(
                    value: _scale.value,
                    divisions: 3,
                    max: 3,
                    onChanged: (v) {
                      object?.scaleRx.value =
                          object.gameObject.scales[v.toInt()];

                      _scale.value = v;
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
        ),
      ),
    );
  }
}
