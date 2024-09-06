import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/emblems/emblems.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblems_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/shapes/shapes_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/base_board.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../uikit/layout_components/containers/containers.dart';

class EmblemsBoard extends EditorBaseBoard {
  EmblemsBoard({super.key})
      : super(
          buildWhen: (p, c) {
            return p.isOpenedEmblemsBoard != c.isOpenedEmblemsBoard;
          },
        );

  @override
  bool getState(FlagEditorState state) {
    return state.isOpenedEmblemsBoard;
  }

  @override
  void onBackgroundTapped(IFlagEditorCubit bloc) {
    bloc.toggleEmblemsBoardOpen(false);
  }

  @override
  Positioned buildWidget(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: constraints.biggest.height / 2,
      child: Material(
        type: MaterialType.card,
        color: Colors.transparent,
        child: build(context),
      ),
    );
  }

  Widget build(BuildContext context) {
    final editorBloc = context.read<IFlagEditorCubit>();

    final sceneObjectsBloc = context.read<EditorSceneObjectsCubit>();
    final cubit = context.read<ShapesBoardCubit>();

    Future<void> onSelect(Emblem value) async {
      final size = value.image.size / 12;

      final effectiveSize = value.image.size / max(size.x, size.y);

      final part = EmblemPart(
        name: UniqueKey().toString(),
        emblem: value,
        initialEmblemSize: value.image.size,
        size: effectiveSize,
      );

      editorBloc.toggleEmblemsBoardOpen(false);
      sceneObjectsBloc.addGameObject(
        part,
      );
    }

    return FCard(
      child: BlocBuilder<EmblemsBoardCubit, EmblemsBoardState>(
        builder: (context, state) {
          return GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              ...state.items.map(
                (e) => ScaledGestureDetector(
                  onTap: () => onSelect(e),
                  child: FCard(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const Pad(all: 2),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: DrawablePaint(
                                drawable: e,
                                size: e.image.size.toSize(),
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            e.name,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
//
// import 'dart:math';
//
//
// import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
// import 'package:flags/domain/game_objects/emblems/emblem.dart';
// import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
// import 'package:flags/features/layers/layer.view.dart';
// import 'package:flags/screens/editor/editor/presentation/controllers/editor.controller.dart';
// import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
// import 'package:flags/uikit/layout_components/containers/card.dart';
// import 'package:flags/uikit/painters/drawable_painter.dart';
// import 'package:flame/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:state_manager/state_manager.dart';
//
// class EditorEmblemsBoard extends UiLayer {
//   const EditorEmblemsBoard({super.key})
//       : super(
//           tag: "editor_emblems",
//           initialShown: false,
//         );
//
//   @override
//   State<StatefulWidget> createState() => EditorEmblemsState();
// }
//
// abstract interface class IEditorEmblemsController implements IUiLayer {}
//
// class EditorEmblemsState
//     extends UiLayerState<EditorEmblemsBoard, IEditorEmblemsController>
//     implements IEditorEmblemsController {
//   late final IEditorPresenter presenter =
//       GetScreen.of<IEditorPresenter>(context).controller;
//
//   final ScrollController scrollController = ScrollController();
//
//   late final emblems = presenter.emblems
//     ..sort(
//       (a, b) => a.name.toLowerCase().compareTo(
//             b.name.toLowerCase(),
//           ),
//     );
//
//   @override
//   void onShow() {
//     scrollController.animateTo(
//       0,
//       duration: const Duration(milliseconds: 250),
//       curve: Curves.easeIn,
//     );
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> onSelect(Emblem value) async {
//     await hide();
//
//     final size = value.image.size / 128;
//
//     final effectiveSize = value.image.size / max(size.x, size.y);
//
//     final part = EmblemPart(
//       name: UniqueKey().toString(),
//       emblem: value,
//       initialEmblemSize: value.image.size,
//       size: effectiveSize,
//     );
//
//     await presenter.addObjectToScene(
//       part,
//     );
//   }
//
//   @override
//   Widget buildChild(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: GestureDetector(
//             onTap: hide,
//             child: const Material(
//               color: Colors.black45,
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: FractionallySizedBox(
//             heightFactor: 0.5,
//             child: FCard(
//               child: ,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
