import 'dart:async';
import 'dart:collection';

import 'package:armar/armar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'consistent_widget.dart';

class ConsistentBuilderProvider extends StatefulWidget {
  const ConsistentBuilderProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static IConsistentBuilder of<T>(BuildContext context) {
    IConsistentBuilder? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<_ConsistentBuilderProviderState>();
    }
    assert(state != null, 'Context does not include a IConsistentBuilder.');

    return state!;
  }

  @override
  State<ConsistentBuilderProvider> createState() => _ConsistentBuilderProviderState();
}

abstract interface class IConsistentBuilder {
  void addToQueue(IConsistentWidget ref);

  void onWidgetDisposed(IConsistentWidget ref);
}

class _ConsistentBuilderProviderState extends State<ConsistentBuilderProvider>
    implements IConsistentBuilder {
  final Queue<IConsistentWidget> _queue = Queue();

  final StreamController _queueStream = StreamController();

  @override
  void initState() {
    super.initState();

    _queueStream.stream
        .debounceTime(const Duration(milliseconds: 1))
        .listen((_) => _startBuildWidget());
  }

  @override
  void dispose() {
    _queueStream.close();
    super.dispose();
  }

  Future<void> _startBuildWidget() async {
    // if (!EasyLoading.isShow) {
    //   EasyLoading.show();
    // }

    if (_queue.isEmpty) {
    //  EasyLoading.dismiss();
      return;
    }

    final current = _queue.removeFirst();
    await current.startBuild();
    if (_queue.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 25));
      await _startBuildWidget();
    } else {
   //   EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void addToQueue(IConsistentWidget ref) {
    _queue.add(ref);
    _queueStream.sink.add(null);
  }

  @override
  void onWidgetDisposed(IConsistentWidget ref) {
    _queue.remove(ref);
  }
}
