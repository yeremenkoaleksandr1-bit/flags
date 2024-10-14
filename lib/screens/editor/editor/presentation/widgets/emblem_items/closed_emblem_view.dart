import 'package:flags/screens/editor/editor/presentation/widgets/emblem_items/emblem_item_view.dart';
import 'package:flutter/material.dart';

class ClosedEmblemItemView extends EmblemItemView {
  const ClosedEmblemItemView(super.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: greyscale,
            child: super.build(context),
          ),
        ),
      ],
    );
  }
}

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);
