import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class AddedMoneyView extends StatelessWidget {
  const AddedMoneyView({
    super.key,
    required this.money,
    required this.widgetKey,
  });

  final Key widgetKey;

  final int money;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 48,
          child: SpriteUIWidget(
            key: widgetKey,
            image: Assets.images.cash.image,
          ),
        ),
        Gap.h12,
        FText(
          money.toString(),
        ),
      ],
    );
  }
}
