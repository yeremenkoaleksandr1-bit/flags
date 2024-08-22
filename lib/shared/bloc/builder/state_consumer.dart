import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/status_bloc_state.dart';
import '../stated_cubit.dart';

class BlocStateConsumerBuilder<T> extends StatelessWidget {
  final Widget Function(dynamic state) builder;

  const BlocStateConsumerBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final state = (context.read<T>() as StatedCubit).state as SuccessState;
    return builder(state.data);
  }
}
