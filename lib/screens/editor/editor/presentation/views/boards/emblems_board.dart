import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/features/layers/layer.view.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/editor.controller.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class EditorEmblemsBoard extends UiLayer {
  const EditorEmblemsBoard({super.key})
      : super(
          tag: "editor_emblems",
          initialShown: false,
        );

  static IEditorEmblemsController find() => Get.find(tag: "editor_emblems");

  @override
  State<StatefulWidget> createState() => EditorEmblemsState();
}

abstract interface class IEditorEmblemsController implements IUiLayer {}

class EditorEmblemsState
    extends UiLayerState<EditorEmblemsBoard, IEditorEmblemsController>
    implements IEditorEmblemsController {
  late final IEditorPresenter presenter =
      GetScreen.of<IEditorPresenter>(context).controller;

  final ScrollController scrollController = ScrollController();

  late final emblems = presenter.emblems
    ..sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    );

  @override
  void onShow() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> onSelect(Emblem value) async {
    await hide();

    final size = value.image.size / 128;

    final effectiveSize = value.image.size / max(size.x, size.y);

    final part = EmblemPart(
      name: UniqueKey().toString(),
      emblem: value,
      initialEmblemSize: value.image.size,
      size: effectiveSize,
    );

    await presenter.addObjectToScene(
      part,
    );
  }

  @override
  Widget buildChild(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: hide,
            child: const Material(
              color: Colors.black45,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: FCard(
              child: GridView.count(
                controller: scrollController,
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children: [
                  ...emblems.map(
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
