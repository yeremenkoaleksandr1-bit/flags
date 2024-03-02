import 'package:armar/components/screens/themes/screen_theme.dart';
import 'package:armar/components/scrollable/ar_scrollable_view.dart';
import 'package:flutter/material.dart';

class ArScreenContent extends StatelessWidget {
  const ArScreenContent({
    super.key,
    required this.child,
    this.scrollController,
    this.removeTopPadding = false,
    this.removeBottomPadding = false,
  });

  final bool removeTopPadding;
  final bool removeBottomPadding;
  final Widget child;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArScreenTheme>()!;
    EdgeInsets padding = theme.contentPadding;

    if (removeTopPadding) {
      padding = padding.copyWith(
        top: 0,
        bottom: padding.bottom,
        left: padding.left,
        right: padding.right,
      );
    }

    if (removeBottomPadding) {
      padding = padding.copyWith(
        top: padding.top,
        bottom: 0,
        left: padding.left,
        right: padding.right,
      );
    }

    return ArScrollableView(
      controller: scrollController,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
