import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_bloc.dart';
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

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FlagEditorBloc>();

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
        BlocProvider(
          create: (_) => EditorAreaCubit(),
        ),
      ],
      child: DeferredPointerHandler(
        child: GamePageBuilder(
          onPageFocussed: () {
            bloc.add(FlagEditorInitializeEvent());
          },
          startSlideDirection: GamePageSlideDirection.bottom,
          endSlideDirection: GamePageSlideDirection.bottom,
          child: const EditorScreenView(),
        ),
      ),
    );
  }
}
