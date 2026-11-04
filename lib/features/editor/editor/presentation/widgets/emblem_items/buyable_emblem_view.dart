import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblems_board_cubit.dart';
import 'package:flags/features/editor/editor/presentation/widgets/emblem_items/emblem_item_view.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BuyableEmblemItemView extends EmblemItemView {
  const BuyableEmblemItemView(super.item, {super.key});

  @override
  BuyableEmblemItem get item => super.item as BuyableEmblemItem;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmblemsBoardCubit>();

    return ScaledGestureDetector(
      onTap: () => cubit.buyEmblem(item),
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 24,
            child: super.build(context),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 24,
                      child: Center(
                        child: UIMoney(),
                      ),
                    ),
                    Gap.h4,
                    FText(
                      item.price.toString(),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
