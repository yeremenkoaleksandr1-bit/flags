import 'dart:math';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/features/games/presentation/puzzle/components/emblem_size_picker.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/emblem.dart';
import 'package:flags/features/games/presentation/puzzle/views/boards/base.dart';
import 'package:flags/uikit/components/buttons/colors/green_button.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmblemEditingBoard extends ProcessObjectEditingBoard {
  const EmblemEditingBoard({super.key, required super.cubit});

  @override
  State<EmblemEditingBoard> createState() => _EmblemEditingBoardState();
}

class _EmblemEditingBoardState
    extends
        ProcessObjectEditingBoardState<
          EmblemEditingBoard,
          EmblemSceneObjectState
        > {
  late final ValueListenable<dynamic> _focusedObject =
      widget.cubit.focusedObject;

  void rotate(bool direction) {
    late final object = _focusedObject.value! as EmblemSceneObjectState;

    var rotation =
        (object.gameObject.rotation + (pi / 4) * (direction ? 1 : -1))
            .remainder(pi * 2);
    if (rotation < 0) {
      rotation += pi * 2;
    }

    object.gameObject.rotation = rotation;
  }

  @override
  Widget buildWidget(
    BuildContext context,
    EmblemSceneObjectState? focussedObject,
  ) {
    return DeferPointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            fit: .loose,
            child: ValueListenableBuilder(
              valueListenable: _focusedObject,
              builder: (BuildContext context, value, Widget? child) {
                if (_focusedObject.value is! EmblemSceneObjectState) {
                  return const SizedBox.shrink();
                }

                late final object =
                    _focusedObject.value as EmblemSceneObjectState;

                return EmblemSizePicker(
                  scales: object.gameObject.scales,
                  initialValue: object.gameObject.scale,
                  onChanged: (double value) {
                    object.gameObject.scale = value;
                  },
                );
              },
            ),
          ),
          Gap.v12,
          Flexible(
            fit: .tight,
            child: Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: FGreenButton(
                    onPressed: () => rotate(false),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(
                        Icons.rotate_90_degrees_ccw_sharp,
                        size: 64.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            
                Expanded(
                  child: FGreenButton(
                    onPressed: () => rotate(true),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(
                        Icons.rotate_90_degrees_cw_outlined,
                        size: 64.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap.v12,
        ],
      ),
    );
    // return PuzzleEmblemObjectStep2Showcase(
    //   showcaseKey: widget.cubit.showcase.emblemObjectStep2,
    //   onTap: () {
    //     widget.cubit.showcase.complete("puzzle_emblem_object");
    //     widget.cubit.showcase.showcaseState.next();
    //   },
    //   child: DeferPointer(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         ValueListenableBuilder(
    //           valueListenable: _focusedObject,
    //           builder: (
    //             BuildContext context,
    //             value,
    //             Widget? child,
    //           ) {
    //             if (_focusedObject.value is! EmblemSceneObjectState) {
    //               return const SizedBox.shrink();
    //             }
    //
    //             late final object =
    //                 _focusedObject.value as EmblemSceneObjectState;
    //
    //             return EmblemSizePicker(
    //               scales: object.gameObject.scales,
    //               initialValue: object.gameObject.scale,
    //               onChanged: (double value) {
    //                 object.gameObject.scale = value;
    //               },
    //             );
    //           },
    //         ),
    //         const Spacer(),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: FGreenButton(
    //                 onPressed: () => rotate(false),
    //                 child: const AspectRatio(
    //                   aspectRatio: 1,
    //                   child: Icon(
    //                     Icons.rotate_90_degrees_ccw_sharp,
    //                     size: 64,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Gap.h24,
    //             Expanded(
    //               child: FGreenButton(
    //                 onPressed: () => rotate(true),
    //                 child: const AspectRatio(
    //                   aspectRatio: 1,
    //                   child: Icon(
    //                     Icons.rotate_90_degrees_cw_outlined,
    //                     size: 64,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const Spacer(
    //           flex: 2,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
