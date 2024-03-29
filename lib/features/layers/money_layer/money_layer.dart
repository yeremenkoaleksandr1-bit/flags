import 'dart:math';

import 'package:armar/armar.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/core/extensions/offset.dart';
import 'package:flags/core/features/object_pooling/object_pool.dart';
import 'package:flags/features/layers/layer.view.dart';
import 'package:flags/features/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flutter/material.dart';

import 'components/money_item.dart';

class UiMoneyLayer extends UiLayer {
  const UiMoneyLayer({super.key})
      : super(
          tag: "money_layer",
          initialShown: false,
        );

  @override
  State<UiLayer> createState() => UiMoneyLayerState();

  static IUiMoneyLayer find() => Get.find(tag: "money_layer");
}

abstract interface class IUiMoneyLayer implements IUiLayer {
  Future<void> addMoneys(Offset fromPosition, int count);
}

class UiMoneyLayerState extends UiLayerState<UiMoneyLayer, IUiMoneyLayer>
    implements IUiMoneyLayer {
  final GlobalKey widgetKey = GlobalKey();

  RenderBox? get moneyRenderBox => widgetKey.currentContext?.renderBox;

  final WidgetsPool<MoneyAnimatedItemController> widgetsPool =
      WidgetsPool(initialSize: 8);

  @override
  Widget buildChild(BuildContext context) {
    return GameSafeArea(
      child: Stack(
        children: [
          TotalMoneysView(
            widgetKey: widgetKey,
          ),
          Stack(
            children: [
              ...widgetsPool.pool.map(
                (e) => MoneyAnimatedView(
                  key: e,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Future<void> addMoneys(Offset fromPosition, int count) async {
    final random = Random();
    if (moneyRenderBox != null) {
      print(count);
      int availableItem = 8;
      int totalMoneys = count;

      await Future.doWhile(() async {
        if (availableItem <= 0) {
          return true;
        }

        totalMoneys--;

        if (totalMoneys <= 0) {
          return false;
        }

        availableItem--;

        await Future.delayed(
          Duration(
            milliseconds: random.nextIntRange(100, 250),
          ),
        );
        if (moneyRenderBox != null) {
          final rect = moneyRenderBox!.rect;

          widgetsPool.acquire(
            onCall: (MoneyAnimatedItemController state) {
              state.playAnimation(
                OVector(fromPosition, rect.center),
                onCompleted: (key) {
                  availableItem++;
                  widgetsPool.release(key);
                },
              );
            },
          );
        }

        return true;
      });
    }
  }
}
