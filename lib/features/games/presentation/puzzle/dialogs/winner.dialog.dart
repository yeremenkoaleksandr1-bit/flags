import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/components/added_money.view.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/components/new_emblems_view.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class PuzzleWinnerDialog extends DialogWidget {
  const PuzzleWinnerDialog({
    super.key,
    required this.level,
    this.nextLevel,
    required this.onExitPressed,
    required this.emblems,
    required this.isLastLevelInSection,
    required this.onNextLevelPressed,
    this.onDoubleRewardPressed,
  });

  final GameLevel level;
  final GameLevel? nextLevel;
  final List<EmblemPart> emblems;
  final bool isLastLevelInSection;
  final void Function(BuildContext context) onExitPressed;
  final void Function(BuildContext context) onNextLevelPressed;
  final Future<bool> Function(BuildContext context)? onDoubleRewardPressed;

  @override
  Widget build(BuildContext context) {
    return _PuzzleWinnerDialogContent(
      level: level,
      nextLevel: nextLevel,
      emblems: emblems,
      isLastLevelInSection: isLastLevelInSection,
      onExitPressed: onExitPressed,
      onNextLevelPressed: onNextLevelPressed,
      onDoubleRewardPressed: onDoubleRewardPressed,
    );
  }
}

class _PuzzleWinnerDialogContent extends StatefulWidget {
  const _PuzzleWinnerDialogContent({
    required this.level,
    required this.nextLevel,
    required this.emblems,
    required this.isLastLevelInSection,
    required this.onExitPressed,
    required this.onNextLevelPressed,
    required this.onDoubleRewardPressed,
  });

  final GameLevel level;
  final GameLevel? nextLevel;
  final List<EmblemPart> emblems;
  final bool isLastLevelInSection;
  final void Function(BuildContext context) onExitPressed;
  final void Function(BuildContext context) onNextLevelPressed;
  final Future<bool> Function(BuildContext context)? onDoubleRewardPressed;

  @override
  State<_PuzzleWinnerDialogContent> createState() =>
      _PuzzleWinnerDialogContentState();
}

class _PuzzleWinnerDialogContentState
    extends State<_PuzzleWinnerDialogContent> {
  final GlobalKey _moneyStartWidgetKey = GlobalKey();

  bool _isMoneyAnimationScheduled = false;
  bool _isDoubleRewardLoading = false;
  bool _isDoubleRewardClaimed = false;

  bool get _isLastLevelInContinent =>
      widget.nextLevel == null && !widget.isLastLevelInSection;

  int get _moneyAward => widget.level.completed ? 0 : widget.level.id;

  bool get _showMoneyAward => _moneyAward != 0;

  bool get _showEmblemsAward => widget.emblems.isNotEmpty;

  bool get _showAwards => _showMoneyAward || _showEmblemsAward;

  bool get _canClaimDoubleReward =>
      widget.onDoubleRewardPressed != null && !_isDoubleRewardClaimed;

  String get _nextLevelButtonText {
    if (_isLastLevelInContinent) {
      return '';
    }

    if (widget.isLastLevelInSection) {
      return 'Next section';
    }

    return 'Next level ${widget.nextLevel!.id + 1}';
  }

  @override
  void initState() {
    super.initState();
    _scheduleMoneyAnimationIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _PuzzleWinnerDialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.level != widget.level ||
        oldWidget.emblems != widget.emblems) {
      _isMoneyAnimationScheduled = false;
      _scheduleMoneyAnimationIfNeeded();
    }
  }

  void _scheduleMoneyAnimationIfNeeded() {
    if (!_showMoneyAward || _isMoneyAnimationScheduled) {
      return;
    }

    _isMoneyAnimationScheduled = true;

    FlutterEngine.widgetPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final currentContext = _moneyStartWidgetKey.currentContext;
      if (currentContext == null) {
        return;
      }

      final renderObject = currentContext.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) {
        return;
      }

      final uiMoneyLayer = UiMoneyLayer.find();

      await uiMoneyLayer.show();
      await uiMoneyLayer.addMoneys(
        renderObject.rect.center,
        _moneyAward.clamp(1, 50),
      );
      await Future.delayed(const Duration(milliseconds: 1250));
      await uiMoneyLayer.hide();
    });
  }

  Future<void> _handleDoubleReward(BuildContext context) async {
    if (!_canClaimDoubleReward || _isDoubleRewardLoading) {
      return;
    }

    setState(() {
      _isDoubleRewardLoading = true;
    });

    final rewarded = await widget.onDoubleRewardPressed!(context);
    if (!mounted) {
      return;
    }

    setState(() {
      _isDoubleRewardLoading = false;
      _isDoubleRewardClaimed = rewarded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        _buildHeader(),
        if (_showAwards) _buildAwards(),
        _buildActions(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: FText(
                '${widget.level.flag.name} - completed!',
                textStyle: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280, maxHeight: 460),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlagView(flag: widget.level.flag),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAwards() {
    return FCard(
      color: ThemePalette.peach,
      child: Column(
        spacing: 12,
        children: [
          if (_showMoneyAward)
            AddedMoneyView(money: _moneyAward, widgetKey: _moneyStartWidgetKey),
          if (_showEmblemsAward) PuzzleNewEmblemView(emblems: widget.emblems),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        if (_canClaimDoubleReward)
          FBlueButton(
            onPressed:
                _isDoubleRewardLoading
                    ? () {}
                    : () {
                      _handleDoubleReward(context);
                    },
            child: Center(
              child: FText(
                _isDoubleRewardLoading
                    ? 'Loading ad...'
                    : 'x2 reward',
                textStyle: const TextStyle(fontSize: 40),
              ),
            ),
          ),
        FGreenButton(
          onPressed: () => widget.onNextLevelPressed(context),
          child: Center(
            child: FText(
              _nextLevelButtonText,
              textStyle: const TextStyle(fontSize: 48),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: FRedButton(
            onPressed: () => widget.onExitPressed(context),
            child: Center(child: FText('Menu')),
          ),
        ),
      ],
    );
  }
}
