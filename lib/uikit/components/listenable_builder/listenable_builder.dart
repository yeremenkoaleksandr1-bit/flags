import 'package:flags/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FListenableBuilder<T extends Listenable> extends StatefulWidget {
  const FListenableBuilder({
    super.key,
    required this.listenable,
    required this.builder,
    this.child,
  });

  final T listenable;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  @override
  State<FListenableBuilder<T>> createState() => _FListenableBuilderState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Listenable>('listenable', listenable));
  }
}

class _FListenableBuilderState<T extends Listenable>
    extends State<FListenableBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(FListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handleChange);
      widget.listenable.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.listenable, widget.child);
  }
}
