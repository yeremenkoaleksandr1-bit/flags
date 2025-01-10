import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/components/animated/shake.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopItemView extends StatefulWidget {
  const ShopItemView({
    super.key,
    required this.tag,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isBouth) builder;

  final String tag;

  @override
  State<ShopItemView> createState() => _ShopItemViewState();
}

class _ShopItemViewState extends State<ShopItemView>
    with SingleTickerProviderStateMixin {
  IShopCubit get cubit => context.read<IShopCubit>();

  String get tag => widget.tag;

  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250,
      ),
    );

    super.initState();
  }

  void onBuy() {
    if (cubit.canBuy(tag)) {
      cubit.buiItem(tag);
      setState(() {});
    } else {
      animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (cubit.isBought(widget.tag)) {
      child = widget.builder(context, true);
    } else {
      final price = cubit.getPrice(widget.tag);

      if (price == -1) {
        child = widget.builder(context, true);
      } else {
        child = ScaledGestureDetector(
          onTap: onBuy,
          child: ShakeWidget(
            controller: animationController,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IgnorePointer(
                  child: Opacity(
                    opacity: 0.25,
                    child: ImageFiltered(
                      imageFilter: ColorFilters.topHighlight,
                      child: widget.builder(context, false),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        height: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlineWidget(
                              child: UIMoney(),
                            ),
                            Gap.h12,
                            FText(
                              "$price",
                              textStyle: const TextStyle(
                                fontSize: 52,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return child;
  }
}
