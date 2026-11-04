import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/features/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
import 'package:flags/uikit/components/buttons/button.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ToggleMagnetAction extends StatelessWidget {
  const ToggleMagnetAction({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MagnetAreaCubit>();

    return BlocBuilder<MagnetAreaCubit, MagnetAreaState>(
      builder: (BuildContext context, MagnetAreaState state) {
        return FButton(
          color:
              state.active ? ThemePalette.yellowButton : ThemePalette.peachCard,
          onPressed: () {
            cubit.setActiveStatus(!state.active);
          },
          child: SizedBox.square(
            dimension: 24,
            child: Icon(
              state.active
                  ? CommunityMaterialIcons.magnet_on
                  : CommunityMaterialIcons.magnet,
            ),
          ),
        );
      },
    );
  }
}
