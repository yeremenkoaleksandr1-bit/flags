import 'package:auto_route/auto_route.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblems_board_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/shapes/shapes_board_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/styles/styles_board_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/features/editor/editor/presentation/screen/editor_screen.view.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/area/area_cubit.dart';
import '../cubits/flag_background_style/flag_background_style_cubit.dart';

@RoutePage()
final class EditorScreen extends StatelessWidget implements AutoRouteWrapper {
  const EditorScreen({
    super.key,
    required this.flag,
  });

  final EditorFlagData flag;

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: GamePageBuilder(
        onPageFocussed: () {},
        startSlideDirection: GamePageSlideDirection.bottom,
        endSlideDirection: GamePageSlideDirection.bottom,
        child: const EditorScreenView(),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IFlagEditorCubit>(
          create: (context) => FlagEditorCubit(
            initialFlag: flag,
            context: context,

          ),
        ),
        BlocProvider(
          create: (_) => EditorFlagBackgroundStyleCubit(
            initialStyle: flag.backgroundStyle,
          ),
        ),
        BlocProvider(
          create: (context) => EditorSceneObjectsCubit(
            editorCubit: context.read<IFlagEditorCubit>(),
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
          create: (_) => StylesBoardCubit(flag.rect),
        ),
        BlocProvider(
          create: (_) => ShapesBoardCubit(),
        ),
        BlocProvider(
          create: (_) => MagnetAreaCubit(),
        ),
        BlocProvider(
          create: (_) => EmblemsBoardCubit(
            context.read<IAppCubit>(),
            context.read<IShopCubit>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
