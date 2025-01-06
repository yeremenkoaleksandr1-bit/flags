import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/features/editor/my_flags/presentation/bloc/my_flags_cubit.dart';
import 'package:flags/features/editor/my_flags/presentation/components/editor_flag_item_drawer.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionsFlagDialog extends DialogWidget {
  const ActionsFlagDialog({
    super.key,
    required this.flag,
    required this.cubit,
  });

  final MyFlagsCubit cubit;
  final EditorFlagData flag;

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return GamePageBuilder(
      startSlideDirection: GamePageSlideDirection.left,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    void onDeleteFlag() {
      cubit.removeFlag(flag);
      Navigator.of(context).pop();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: flag.proportion,
                child: FittedBox(
                  child: EditorFlagItemDrawer(flag: flag),
                ),
              ),
              Gap.v12,
              WrapSuper(
                children: [
                  FRedButton(
                    onPressed: onDeleteFlag,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
