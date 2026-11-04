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

class MoneyDisplayConfig {
  const MoneyDisplayConfig({
    this.paddingRight,
    this.pillHeight,
    this.pillTop,
    this.iconHeight,
    this.iconOffsetTop,
    this.iconOffsetLeft,
    this.fontSize,
    this.strokeWidth,
    this.paddingLeft,
    this.paddingRight2,
    this.paddingTop,
  });

  final double? paddingRight;
  final double? pillHeight;
  final double? pillTop;
  final double? iconHeight;
  final double? iconOffsetTop;
  final double? iconOffsetLeft;
  final double? fontSize;
  final double? strokeWidth;
  final double? paddingLeft;
  final double? paddingRight2;
  final double? paddingTop;
}

abstract interface class IUiMoneyLayer implements IUiLayer {
  Future<void> addMoneys(Offset Function() fromPosition, int count);
  void setDisplayConfig(MoneyDisplayConfig? config);
}

class UiMoneyLayerState extends UiLayerState<UiMoneyLayer, IUiMoneyLayer>
    implements IUiMoneyLayer {
  final GlobalKey widgetKey = GlobalKey();

  RenderBox? get moneyRenderBox => widgetKey.currentContext?.findRenderObject() as RenderBox?;

  final WidgetsPool<MoneyAnimatedItemController> widgetsPool =
      WidgetsPool(initialSize: 20);

  MoneyDisplayConfig? _displayConfig;

  @override
  void setDisplayConfig(MoneyDisplayConfig? config) {
    setState(() => _displayConfig = config);
  }

  @override
  Widget buildChild(BuildContext context) {
    final cfg = _displayConfig;
    return GameSafeArea(
      child: Stack(
        children: [
          TotalMoneysView(
            widgetKey: widgetKey,
            paddingRight:  cfg?.paddingRight,
            pillHeight:    cfg?.pillHeight,
            pillTop:       cfg?.pillTop,
            iconHeight:    cfg?.iconHeight,
            iconOffsetTop: cfg?.iconOffsetTop,
            iconOffsetLeft:cfg?.iconOffsetLeft,
            fontSize:      cfg?.fontSize,
            strokeWidth:   cfg?.strokeWidth,
            paddingLeft:   cfg?.paddingLeft,
            paddingRight2: cfg?.paddingRight2,
            paddingTop:    cfg?.paddingTop,
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

  StreamSubscription<dynamic>? _subscription;

  Completer<dynamic>? _availableCompleter;
  Completer<dynamic>? _completer;

  @override
  Future<void> addMoneys(Offset Function() fromPosition, int count) async {
    _subscription?.cancel();
    _subscription = null;

    if (count <= 0 || moneyRenderBox == null) {
      return;
    }

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
        _subscription = null;
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
              OVector(fromPosition(), rect.center),
              onCompleted: (key) {
                availableItem++;

                widgetsPool.release(key);
                if (availableItem > 0) {
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

    return _completer?.future ?? Future.value();
  }
}
