import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildVibrationPreferences extends StatelessWidget {
  const BuildVibrationPreferences({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final Widget Function(
    BuildContext context,
    VibrationState state,
  ) builder;

  final bool Function(
    VibrationState previous,
    VibrationState current,
  )? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IVibrationCubit, VibrationState>(
      bloc: context.read<IVibrationCubit>(),
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
