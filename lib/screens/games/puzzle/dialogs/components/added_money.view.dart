import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../uikit/uikit.dart';

class AddedMoneyView extends StatelessWidget {
  const AddedMoneyView({super.key, required this.money});

  final int money;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox.square(
          dimension: 48,
          child: SpriteUIWidget(image: Assets.images.cash.image),
        ),
        Gap.h12,
        FText(money.toString()),
      ],
    );
  }
}
