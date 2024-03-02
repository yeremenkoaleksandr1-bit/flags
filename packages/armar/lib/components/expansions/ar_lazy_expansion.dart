import 'package:flutter/material.dart';

import 'package:armar/armar.dart';

class ArLazyExpansionPanel extends StatefulWidget {
  const ArLazyExpansionPanel({
    super.key,
    required this.title,
    required this.content,
    this.initiallyActivity = false,
    this.wrapper,
  });

  final Widget Function(bool active) title;
  final Widget Function() content;

  final Widget Function(bool active, Widget child)? wrapper;

  final bool initiallyActivity;

  @override
  State<ArLazyExpansionPanel> createState() => ArLazyExpansionPanelState();
}

abstract class ArExpansionPanelState<T extends StatefulWidget>
    extends State<T> {
  static ArExpansionPanelState<T> of<T extends StatefulWidget>(
      BuildContext context) {
    ArExpansionPanelState<T>? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<ArExpansionPanelState<T>>();
    }

    assert(() {
      if (state == null) {
        throw FlutterError('Context does not include a IExpansionPanelState.');
      }
      return true;
    }());

    return state!;
  }

  void openPanel();

  void closePanel();

  bool get panelStatus;
}

class ArLazyExpansionPanelState
    extends ArExpansionPanelState<ArLazyExpansionPanel> {
  late final RxBool _active = widget.initiallyActivity.rx;

  late final RxValue<Widget?> _content = RxValue(null);

  void toggleActive() {
    _active.value = !_active.value;

    if (_content.value == null && _active.value) {
      _content.value = widget.content();
    }
  }

  @override
  void didUpdateWidget(covariant ArLazyExpansionPanel oldWidget) {
    if (oldWidget.initiallyActivity != widget.initiallyActivity) {
      _active.value = widget.initiallyActivity;
    }
    _content.value = widget.content();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FastBuilder(() {
        Widget child = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: toggleActive,
              child: widget.title(_active.value),
            ),
            ArCrossFade(
              active: _active.value,
              child: _content.value ?? nil,
            ),
          ],
        );

        if (widget.wrapper != null) {
          child = widget.wrapper!.call(_active.value, child);
        }

        return child;
      }),
    );
  }

  @override
  void closePanel() {
    _active.value = false;
  }

  @override
  void openPanel() {
    _active.value = true;
  }

  @override
  bool get panelStatus => _active.value;
}
