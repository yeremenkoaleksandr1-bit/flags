import 'dart:io';
import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/core/utils/calculator.dart';
import 'package:flags/domain/game_objects/emblems/emblems.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblems_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/base_board.dart';
import 'package:flags/screens/editor/editor/presentation/widgets/factories/emblem_item_factory.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flags/uikit/text/text.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

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
    final sceneObjectsBloc = context.read<EditorSceneObjectsCubit>();

    Future<void> uploadImageToBoard() async {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        EasyLoading.show();
        final path = result.paths.first;
        final file = File(path!);

        final hashedFileName = shortHash(file.path) +
            shortHash(file.hashCode.toString()) +
            shortHash(Random());

        final image = Image.file(file).image;
        final uiImage = await image.image;

        final size = Vector2(
          uiImage.width.toDouble(),
          uiImage.height.toDouble(),
        );

        final String localPatch =
            (await getApplicationDocumentsDirectory()).path;

        final File copiedImage = await file.copy('$localPatch/$hashedFileName');

        final fraction = Calculator.fraction(
          const Size.square(16),
          size.toSize(),
        );

        final ImageGameObject imageGameObject = await ImageGameObject(
          imagePath: copiedImage.path,
          name: hashedFileName,
          size: size * fraction,
        ).init();

        sceneObjectsBloc.addGameObject(
          imageGameObject,
        );
        EasyLoading.dismiss();
      }
    }

    return FCard(
      child: BlocBuilder<EmblemsBoardCubit, EmblemsBoardState>(
        builder: (context, state) {
          return SafeArea(
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...state.items.map(
                        (e) {
                          return EmblemItemFactory(
                            item: e,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FYellowButton(
                  onPressed: uploadImageToBoard,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FText(
                        "upload image",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
