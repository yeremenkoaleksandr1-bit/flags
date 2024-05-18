import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragAndDropProvider extends StatefulWidget {
  const DragAndDropProvider({
    required this.builder,
    super.key,
  });

  final WidgetBuilder builder;

  @override
  State<DragAndDropProvider> createState() => _DragAndDropProviderState();
}

abstract interface class IDragAndDropProvider {
  static IDragAndDropProvider of(BuildContext context) {
    final _DragAndDropProviderState? state =
        context.findAncestorStateOfType<_DragAndDropProviderState>();

    assert(state != null);

    return state! as IDragAndDropProvider;
  }

  void addWidget(Widget Function() builder, Offset position);

  void updateWidget(Offset position);

  void removeWidget();
}

class _DragAndDropProviderState extends State<DragAndDropProvider>
    implements IDragAndDropProvider {
  final ValueNotifier<Widget?> widgetItem = ValueNotifier(null);
  final ValueNotifier<Offset> position = ValueNotifier(Offset.zero);

  final GlobalKey key = GlobalKey();

  @override
  void dispose() {
    widgetItem.dispose();
    position.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: widget.builder,
        ),
        ValueListenableBuilder(
          valueListenable: widgetItem,
          builder: (
            BuildContext context,
            Widget? value,
            Widget? child,
          ) {
            if (value == null) {
              return const SizedBox.shrink();
            }

            return ValueListenableBuilder(
              valueListenable: position,
              builder: (
                BuildContext context,
                Offset value,
                Widget? child,
              ) {
                return Transform.translate(
                  key: key,
                  offset: value,
                  child: child,
                );
              },
              child: value,
            );
          },
        ),
      ],
    );
  }

  @override
  void addWidget(Widget Function() builder, Offset position) {
    widgetItem.value = builder();
    this.position.value = position;
  }

  @override
  void removeWidget() {
    widgetItem.value = null;
  }

  @override
  void updateWidget(Offset position) {
    this.position.value = position;
  }
}
