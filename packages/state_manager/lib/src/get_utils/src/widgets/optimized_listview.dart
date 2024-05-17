import 'package:flutter/material.dart';

import 'nil.dart';

class OptimizedListView<T> extends StatelessWidget {
  final List<T> list;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget onEmpty;
  final int length;
  final Widget Function(BuildContext context, ValueKey key, T item) builder;
  final Widget Function()? spaceBetween;

  const OptimizedListView({
    Key? key,
    required this.list,
    required this.builder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.onEmpty = const SizedBox.shrink(),
    this.shrinkWrap = false,
    this.spaceBetween,
  })  : length = list.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return onEmpty;

    final withSpaceBetween = spaceBetween != null;
    final length = withSpaceBetween ? list.length * 2 - 1 : list.length;

    return CustomScrollView(
      controller: controller,
      reverse: reverse,
      scrollDirection: scrollDirection,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (withSpaceBetween && index % 2 == 1) {
                return spaceBetween!.call();
              }

              final actualIndex = withSpaceBetween ? (index ~/ 2) : index;

              if (actualIndex < 0 || actualIndex >= list.length) {
                return const SizedBox();
              }

              final item = list[actualIndex];
              final key = ValueKey(item);

              return builder(context, key, item);
            },
            childCount: length,
            addAutomaticKeepAlives: true,
            findChildIndexCallback: (Key key) =>
                list.indexWhere((m) => key == ValueKey(m)),
          ),
        ),
      ],
    );
  }
}
