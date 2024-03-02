import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:html/parser.dart';

class ArHtmlBuilder extends StatefulWidget {
  const ArHtmlBuilder(
    this.html, {
    super.key,
  });

  final String html;

  @override
  State<ArHtmlBuilder> createState() => ArHtmlBuilderState();
}

abstract interface class IArHtmlBuilderController {
  Future<void> buildWidget();
}

class ArHtmlBuilderState extends State<ArHtmlBuilder>
    implements IArHtmlBuilderController {
  late final _provider = ArHtmlBuildingProvider.of(context)!;

  late final RxValue<Widget?> _htmlDom = RxValue(null);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.addToQueue(this);
    });
  }

  @override
  Future<void> buildWidget() async {
    final document = parse(widget.html);
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );

    _htmlDom.value = ArText(document.outerHtml);
  }

  @override
  Widget build(BuildContext context) {
    return FastValueBuilder(
      listen: _htmlDom,
      builder: (Widget? child) {
        if (child == null) {
          return const ArText("...");
        }

        return child;
      },
    );
  }
}
