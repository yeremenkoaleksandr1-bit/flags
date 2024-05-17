import 'package:flutter/cupertino.dart';

class SeparatedListView extends ListView {
  SeparatedListView({
    super.key,
    required List<Widget> children,
    required Widget gap,
    ScrollPhysics physics = const NeverScrollableScrollPhysics(),
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = true,
    Clip clipBehavior = Clip.hardEdge,
    super.reverse,
    super.restorationId,
    super.addRepaintBoundaries,
    super.controller,
    super.addAutomaticKeepAlives,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.dragStartBehavior,
    super.findChildIndexCallback,
    super.keyboardDismissBehavior,
    super.padding,
    super.primary,
  }) : super.separated(
          physics: physics,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap,
          clipBehavior: clipBehavior,
          itemBuilder: (_, index) => children[index],
          separatorBuilder: (_, __) => gap,
          itemCount: children.length,
        );
}

class SeparatedScrollableListView extends ListView {
  SeparatedScrollableListView({
    super.key,
    required List<Widget> children,
    required Widget gap,
    super.physics,
    super.shrinkWrap,
    Axis scrollDirection = Axis.vertical,
    Clip clipBehavior = Clip.hardEdge,
    super.reverse,
    super.restorationId,
    super.addRepaintBoundaries,
    super.controller,
    super.addAutomaticKeepAlives,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.dragStartBehavior,
    super.findChildIndexCallback,
    super.keyboardDismissBehavior,
    super.padding,
    super.primary,
  }) : super.separated(
          scrollDirection: scrollDirection,
          clipBehavior: clipBehavior,
          itemBuilder: (_, index) => children[index],
          separatorBuilder: (_, __) => gap,
          itemCount: children.length,
        );
}
