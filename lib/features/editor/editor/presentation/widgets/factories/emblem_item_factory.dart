import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';
import 'package:flags/features/editor/editor/presentation/widgets/emblem_items/emblem_item_view.dart';
import 'package:flags/features/editor/editor/presentation/widgets/emblem_items/opened_emblem_view.dart';
import 'package:flutter/material.dart';

import '../emblem_items/buyable_emblem_view.dart';
import '../emblem_items/closed_emblem_view.dart';

class EmblemItemFactory extends StatefulWidget {
  const EmblemItemFactory({
    super.key,
    required this.item,
  });

  final EmblemItem item;

  @override
  State<EmblemItemFactory> createState() => _EmblemItemFactoryState();
}

class _EmblemItemFactoryState extends State<EmblemItemFactory> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.item) {
      ClosedEmblemItem() => ClosedEmblemItemView.new,
      OpenedEmblemItem() => OpenedEmblemItemView.new,
      BuyableEmblemItem() => BuyableEmblemItemView.new,
      GameEmblemItem() => ClosedEmblemItemView.new,
    }(widget.item);
  }
}
