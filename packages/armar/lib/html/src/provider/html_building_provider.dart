import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../logger.dart';
import '../builder/html_builder.dart';

class ArHtmlBuildingProvider extends StatefulWidget {
  const ArHtmlBuildingProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static IArHtmlBuildingProvider? of(BuildContext context) =>
      context.findAncestorStateOfType<ArHtmlBuildingProviderState>();

  @override
  State<ArHtmlBuildingProvider> createState() => ArHtmlBuildingProviderState();
}

abstract interface class IArHtmlBuildingProvider {
  void addToQueue(IArHtmlBuilderController controller);

  Future<void> onHtmlWidgetReady();
}

class ArHtmlBuildingProviderState extends State<ArHtmlBuildingProvider>
    implements IArHtmlBuildingProvider {
  IArHtmlBuilderController? _currentInstance;

  late Queue<IArHtmlBuilderController> htmlBuildersQueue = Queue();

  final PublishSubject<IArHtmlBuilderController> subject =
      PublishSubject<IArHtmlBuilderController>();

  @override
  void initState() {
    subject.listen((event) async {
      await event.buildWidget();
      logger.f("test");
    });
    super.initState();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> _startBuild() async {
    logger.f(htmlBuildersQueue.length);
    if (htmlBuildersQueue.isNotEmpty) {
      _currentInstance = htmlBuildersQueue.removeFirst();
      await _currentInstance?.buildWidget();
    }
  }

  @override
  Future<void> onHtmlWidgetReady() async {
    await _startBuild();
  }

  @override
  void addToQueue(IArHtmlBuilderController controller) {
    subject.add(controller);
  }
}
