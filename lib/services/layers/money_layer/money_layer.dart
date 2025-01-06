import 'dart:async';
import 'dart:math';

import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/core/extensions/offset.dart';
import 'package:flags/core/features/object_pooling/object_pool.dart';
import 'package:flags/services/layers/layer.view.dart';
import 'package:flags/services/layers/money_layer/components/money_item.dart';
import 'package:flags/services/layers/money_layer/components/total_moneys_view.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flutter/material.dart';

class UiMoneyLayer extends UiLayer {
  const UiMoneyLayer({super.key})
      : super(
          tag: "money_layer",
          initialShown: false,
        );

  @override
  State<UiLayer> createState() => UiMoneyLayerState();

  static IUiMoneyLayer find() => IUiLayer.find("money_layer") as IUiMoneyLayer;
}

abstract interface class IUiMoneyLayer implements IUiLayer {
  Future<void> addMoneys(Offset fromPosition, int count);
}

class UiMoneyLayerState extends UiLayerState<UiMoneyLayer, IUiMoneyLayer>
    implements IUiMoneyLayer {
  final GlobalKey widgetKey = GlobalKey();

  RenderBox? get moneyRenderBox => widgetKey.currentContext?.findRenderObject() as RenderBox?;

  final WidgetsPool<MoneyAnimatedItemController> widgetsPool =
      WidgetsPool(initialSize: 20);

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

  late StreamSubscription<dynamic>? _subscription = null;

  late Completer<dynamic>? _availableCompleter;
  late Completer<dynamic>? _completer;

  @override
  Future<void> addMoneys(Offset fromPosition, int count) async {
    _subscription?.cancel();

    if (moneyRenderBox != null) {
      final Random random = Random();
      _completer = Completer();
      int availableItem = 20;
      int totalMoneys = count;

      _subscription = Stream.periodic(
        const Duration(milliseconds: 100),
      ).listen((event) async {
        if (availableItem <= 0) {
          await _availableCompleter?.future;
        }
        totalMoneys--;
        if (totalMoneys <= 0) {
          _subscription?.cancel();
          if (_completer != null && !_completer!.isCompleted) {
            _completer?.complete();
          }
        }

        if (moneyRenderBox != null) {
          final rect = moneyRenderBox!.rect;

          widgetsPool.acquire(
            onCall: (MoneyAnimatedItemController state) async {
              availableItem--;

              if (availableItem <= 0) {
                _availableCompleter = Completer();
              }

              await Future.delayed(
                Duration(
                  milliseconds: random.nextIntRange(100, 250),
                ),
              );

              state.playAnimation(
                OVector(fromPosition, rect.center),
                onCompleted: (key) {
                  availableItem++;

                  widgetsPool.release(key);
                  if (availableItem <= 0) {
                    if (_availableCompleter != null &&
                        !_availableCompleter!.isCompleted) {
                      _availableCompleter?.complete();
                    }
                  }
                },
              );
            },
          );
        }
      });
    }

    return _completer?.future;
  }
}
