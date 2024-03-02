import 'dart:async';

import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:armar/rx/rx.dart';
import 'package:flutter/material.dart';

import 'consistent_builder.dart';

enum WidgetBuildingStatus {
  ready,
  building,
  waiting,
}

class ConsistentWidget extends StatefulWidget {
  const ConsistentWidget({
    required super.key,
    required this.builder,
    this.placeholder,
  });

  final WidgetBuilder builder;
  final Widget? placeholder;

  @override
  State<ConsistentWidget> createState() => _ConsistentWidgetState();
}

abstract interface class IConsistentWidget {
  Future<void> startBuild();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

class _ConsistentWidgetState extends State<ConsistentWidget>
    implements IConsistentWidget {
  final GlobalKey _key = GlobalKey();

  late final _builder = ConsistentBuilderProvider.of(context);

  final RxValue<WidgetBuildingStatus> _status =
      RxValue(WidgetBuildingStatus.waiting);

  @override
  void initState() {
    _builder.addToQueue(this);
    super.initState();
  }

  final Completer _completer = Completer();

  @override
  Future<void> startBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _status.value = WidgetBuildingStatus.ready;
      _completer.complete();
    });

    return _completer.future;
  }

  @override
  void dispose() {
    _builder.onWidgetDisposed(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FastValueBuilder(
      listen: _status,
      builder: (WidgetBuildingStatus value) {
        if (value == WidgetBuildingStatus.ready) {
          return widget.builder(context);
        }

        return widget.placeholder ?? const SizedBox();
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ConsistentWidgetState &&
          runtimeType == other.runtimeType &&
          _key == other._key;

  @override
  int get hashCode => _key.hashCode;
}
