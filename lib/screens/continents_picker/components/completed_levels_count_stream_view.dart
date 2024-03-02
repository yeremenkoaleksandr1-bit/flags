import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/continent_type.dart';
import '../../../domain/enums/game_mode_type.dart';

class CompletedLevelsCountStreamBuilder extends StatefulWidget {
  const CompletedLevelsCountStreamBuilder({
    super.key,
    required this.continent,
    required this.gameMode,
    required this.builder,
  });

  final ContinentType continent;
  final GameProcessType gameMode;

  final Widget Function(int quantity) builder;

  @override
  State<CompletedLevelsCountStreamBuilder> createState() =>
      _CompletedLevelsCountStreamBuilderState();
}

class _CompletedLevelsCountStreamBuilderState
    extends State<CompletedLevelsCountStreamBuilder> {
  late final stream = ILevelsService.I.watchCompletedLevelsQuantity(
    continent: widget.continent,
    gameMode: widget.gameMode,
  );

  late final initialValue = ILevelsService.I.getCompletedLevelsQuantity(
    continent: widget.continent,
    gameMode: widget.gameMode,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initialValue,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return widget.builder(snapshot.data!);
      },
    );
  }
}
