import 'package:state_manager/state_manager.dart';
import 'package:flags/features/layers/layer.view.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/editor.controller.dart';
import 'package:flags/screens/editor/editor/presentation/components/flag_style.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/material.dart';

class EditorStylesBoard extends UiLayer {
  const EditorStylesBoard({super.key})
      : super(
          tag: "editor_styles",
          initialShown: false,
        );

  static IEditorStylesController find() => Get.find(tag: "editor_styles");

  @override
  State<StatefulWidget> createState() => EditorStylesState();
}

abstract interface class IEditorStylesController implements IUiLayer {}

class EditorStylesState
    extends UiLayerState<EditorStylesBoard, IEditorStylesController>
    implements IEditorStylesController {
  late final IEditorPresenter presenter =
      GetScreen.of<IEditorPresenter>(context).controller;

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
                  ...presenter.backgroundStyles.entries.map(
                    (e) => ScaledGestureDetector(
                      onTap: () => presenter.selectBackgroundStyle(e.value),
                      child: FCard(
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: presenter.flag.proportion,
                                  child: FlagStyleView(
                                    style: e.value,
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
