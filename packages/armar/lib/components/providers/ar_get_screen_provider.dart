import 'package:flutter/widgets.dart';

import '../../state_management/get.dart';

abstract class ArGetScreen<T> extends StatefulWidget {
  const ArGetScreen({
    super.key,
    required this.presenter,
    this.tag,
  });

  final String? tag;
  final T Function() presenter;

  Widget build(BuildContext context, T presenter);

  static ArGetScreenState<G> of<G>(BuildContext context) {
    ArGetScreenState<G>? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<ArGetScreenState<G>>();
    }

    assert(state != null, 'Context does not include a ArGetScreenProvider.');

    return state!;
  }

  @override
  State<ArGetScreen<T>> createState() => ArGetScreenState<T>();
}

class ArGetScreenState<T> extends State<ArGetScreen<T>> {
  late final String _tag = (widget.tag ?? UniqueKey()).toString();

  late final T presenter;

  @override
  void initState() {
    presenter = Get.put<T>(widget.presenter(), tag: _tag);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<T>(tag: _tag);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, presenter);
}

class ArGetScreenBuilder<T> extends StatefulWidget {
  const ArGetScreenBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(T provider) builder;

  @override
  State<ArGetScreenBuilder<T>> createState() => _ArGetScreenBuilderState<T>();
}

class _ArGetScreenBuilderState<T> extends State<ArGetScreenBuilder<T>> {
  late final _presenter = ArGetScreen.of<T>(context).presenter;

  @override
  Widget build(BuildContext context) => widget.builder(_presenter);
}

abstract class ArGetLocatorWidget<T> extends StatefulWidget {
  const ArGetLocatorWidget({
    super.key,
  });

  Widget build(BuildContext context, T presenter);

  @override
  State<ArGetLocatorWidget<T>> createState() => _ArGetLocatorWidgetState();
}

class _ArGetLocatorWidgetState<T> extends State<ArGetLocatorWidget<T>> {
  late final _presenter = ArGetScreen.of<T>(context).presenter;

  @override
  Widget build(BuildContext context) {
    return widget.build(
      context,
      _presenter,
    );
  }
}
