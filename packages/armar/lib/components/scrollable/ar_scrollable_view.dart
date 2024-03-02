import 'package:armar/armar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../logger.dart';
import '../../ui/ui.dart';
import 'themes/ar_scrollable_view_theme.dart';

class ArScrollableView extends StatefulWidget {
  const ArScrollableView({
    super.key,
    required this.child,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.restorationId,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.thumbColor,
    this.trackColor,
    this.trackBorderColor,
    this.thumbVisibility,
    this.trackVisibility,
  });

  final Widget child;

  final Axis scrollDirection;
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Color? thumbColor;
  final Color? trackColor;
  final Color? trackBorderColor;

  @override
  State<ArScrollableView> createState() => ArScrollableViewState();

  static ArScrollableViewState of(BuildContext context) {
    ArScrollableViewState? state;

    if (context is StatefulElement) {
      state = context.findAncestorStateOfType<ArScrollableViewState>();
    }
    assert(state != null, 'Context does not include a CuScrollableViewState.');

    return state!;
  }
}

class ArScrollableViewState extends State<ArScrollableView>
    with KeyboardManager {
  ScrollController get scrollController => _controller;

  late final ScrollController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArScrollableViewTheme>()!;

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: RawScrollbar(
        thumbColor: widget.thumbColor ?? theme.thumbColor,
        controller: _controller,
        thumbVisibility: widget.thumbVisibility,
        trackVisibility: widget.trackVisibility,
        trackColor: widget.trackColor ?? theme.trackColor,
        trackRadius: theme.trackRadius ?? const Radius.circular(4),
        trackBorderColor: widget.trackBorderColor,
        crossAxisMargin: 1,
        radius: theme.radius ?? const Radius.circular(4),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            padding: widget.padding,
            primary: widget.primary,
            dragStartBehavior: widget.dragStartBehavior,
            clipBehavior: widget.clipBehavior,
            restorationId: widget.restorationId,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            controller: _controller,
            child: RepaintBoundary(
              child: SizeChangedLayoutNotifier(
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArRawScrollbar extends StatelessWidget {
  const ArRawScrollbar({
    super.key,
    required this.child,
    this.thumbColor,
    this.trackColor,
    this.thumbVisibility,
    this.trackVisibility,
    this.trackBorderColor,
    this.controller,
  });

  final Widget child;

  final bool? thumbVisibility;
  final bool? trackVisibility;

  final Color? thumbColor;
  final Color? trackColor;
  final Color? trackBorderColor;

  final ScrollController? controller;


  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RawScrollbar(
      thumbColor: thumbColor ?? theme.primaryColor,
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      trackColor: trackColor ,
      trackRadius: const Radius.circular(4),
      trackBorderColor: trackBorderColor,
      crossAxisMargin: 1,
      radius: const Radius.circular(4),
      child: child,
    );
  }
}

