// ignore_for_file: use_build_context_synchronously

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:state_manager/state_manager.dart';

abstract class GetScreen<T> extends StatefulWidget {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  const GetScreen({
    super.key,
    required this.controller,
    this.tag,
  });

  final String? tag;
  final T Function(BuildContext context) controller;

  void onInit(BuildContext context) {}

  void onPreInit(BuildContext context) {}

  void onReady(BuildContext context) {}

  void onScreenFocussed(BuildContext context) {}

  void onScreenUnfocused(BuildContext context) {}

  void onClose() {}

  Widget build(BuildContext context, T controller);

  static GetScreenState<G> of<G>(BuildContext context) {
    GetScreenState<G>? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<GetScreenState<G>>();
    }

    assert(state != null, 'Context does not include a GetScreen.');

    return state!;
  }

  @override
  State<GetScreen<T>> createState() => GetScreenState<T>();
}

class GetScreenState<T> extends State<GetScreen<T>> with RouteAware {
  late final String _tag = (widget.tag ?? UniqueKey()).toString();

  late final T controller;

  @override
  void initState() {
    widget.onPreInit(context);
    controller = Get.put<T>(widget.controller(context), tag: _tag);
    super.initState();
    widget.onInit(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onReady(context);
    });
  }

  @override
  void dispose() {
    widget.onClose();
    GetScreen.routeObserver.unsubscribe(this);
    Get.delete<T>(tag: _tag, force: true);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null) {
      GetScreen.routeObserver.subscribe(
        this,
        ModalRoute.of(context)!,
      );

      if (ModalRoute.of(context)!.isCurrent) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.onScreenFocussed(context);
        });
      } else {
        widget.onScreenUnfocused(context);
      }
    }
  }

  @override
  void didPop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onScreenUnfocused(context);
    });
    super.didPop();
  }

  @override
  void didPushNext() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onScreenUnfocused(context);
    });

    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, controller);
}

abstract class GetConsumer<T> extends StatefulWidget {
  const GetConsumer({
    super.key,
  });

  Widget build(BuildContext context, T controller);

  @override
  State<GetConsumer<T>> createState() => _GetConsumerState();
}

class _GetConsumerState<T> extends State<GetConsumer<T>> {
  late final _presenter = GetScreen.of<T>(context).controller;

  @override
  Widget build(BuildContext context) {
    return widget.build(
      context,
      _presenter,
    );
  }
}

class GetConsumerBuilder<T> extends GetConsumer<T> {
  final Widget Function(BuildContext context, T controller) builder;

  const GetConsumerBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context, T presenter) =>
      builder(context, presenter);
}
