import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblems_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/shapes/shapes_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/styles/styles_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/screen/editor_screen.view.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/area/area_cubit.dart';
import '../cubits/flag_background_style/flag_background_style_cubit.dart';

final class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EditorFlagBackgroundStyleCubit(
            initialStyle: bloc.initialFlag.backgroundStyle,
          ),
        ),
        BlocProvider(
          create: (_) => EditorSceneObjectsCubit(
            initialObjects: bloc.initialFlag.objects,
          ),
        ),
        BlocProvider(
          create: (_) => EditorSelectedObjectCubit(),
        ),
        //boards
        BlocProvider(
          create: (_) => EditorAreaCubit(),
        ),
        BlocProvider(
          create: (_) => StylesBoardCubit(bloc.initialFlag.rect),
        ),
        BlocProvider(
          create: (_) => ShapesBoardCubit(),
        ),
        BlocProvider(
          create: (_) => MagnetAreaCubit(),
        ),
        BlocProvider(
          create: (_) => EmblemsBoardCubit(ShopProvider.of(context)),
        ),
      ],
      child: DeferredPointerHandler(
        child: GamePageBuilder(
          onPageFocussed: () {},
          startSlideDirection: GamePageSlideDirection.bottom,
          endSlideDirection: GamePageSlideDirection.bottom,
          child: const EditorScreenView(),
        ),
      ),
    );
  }
}
