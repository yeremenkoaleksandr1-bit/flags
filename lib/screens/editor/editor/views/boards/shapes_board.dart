import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/editor/shapes/shapes.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/layers/layer.view.dart';
import 'package:flags/presentation/presenters/editor/editor.presenter.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flutter/material.dart';

class EditorShapesBoard extends UiLayer {
  const EditorShapesBoard({super.key})
      : super(
          tag: "editor_shapes",
          initialShown: false,
        );

  static IEditorShapesController find() => Get.find(tag: "editor_shapes");

  @override
  State<StatefulWidget> createState() => EditorShapesState();
}

abstract interface class IEditorShapesController implements IUiLayer {}

class EditorShapesState
    extends UiLayerState<EditorShapesBoard, IEditorShapesController>
    implements IEditorShapesController {
  late final IEditorPresenter presenter =
      ArGetScreen.of<IEditorPresenter>(context).presenter;

  final ScrollController scrollController = ScrollController();

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

  Future<void> onShapeChose(SShape shape) async {
    await hide();
    await presenter.addObjectToScene(
      PathGameObject(
        name: UniqueKey().toString(),
        path: shape,
      ),
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
            heightFactor: 0.4,
            child: FCard(
              child: GridView.count(
                controller: scrollController,
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children: [
                  ...presenter.state.shapes.entries.map(
                    (e) => ScaledGestureDetector(
                      onTap: () => onShapeChose(e.value),
                      child: FCard(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const Pad(all: 12),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox.fromSize(
                                    size: e.value.rect.size,
                                    child: DrawablePaint(
                                      drawable: e.value,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(e.key),
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
