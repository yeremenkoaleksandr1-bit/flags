import 'dart:math' as math;

import 'package:flags/app/app_scope.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/debug/debug_tools.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: FGreenButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const _DebugDialog(),
        ),
        child: const Text('DEBUG'),
      ),
    );
  }
}

class _DebugDialog extends StatefulWidget {
  const _DebugDialog();

  @override
  State<_DebugDialog> createState() => _DebugDialogState();
}

class _DebugDialogState extends State<_DebugDialog> {
  final TextEditingController _moneyController = TextEditingController(
    text: '100',
  );

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  int get _moneyDelta {
    final parsedValue = int.tryParse(_moneyController.text.trim());
    if (parsedValue == null || parsedValue <= 0) {
      return 100;
    }
    return parsedValue;
  }

  Future<void> _unlockAllLevels() async {
    final sharedPreferences = AppScope.bootstrapOf(context).sharedPreferences;
    await DebugTools.unlockAllLevels(sharedPreferences);
    if (!mounted) {
      return;
    }
    EasyLoading.showSuccess('All levels unlocked');
  }

  void _addMoney() {
    final amount = _moneyDelta;
    context.read<GamePreferencesCubit>().addMoney(amount);
    EasyLoading.showSuccess('+$amount coins');
  }

  void _removeMoney() {
    final amount = _moneyDelta;
    final cubit = context.read<GamePreferencesCubit>();
    final safeAmount = math.min(amount, cubit.state.moneys);
    cubit.removeMoney(safeAmount);
    EasyLoading.showSuccess('-$safeAmount coins');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Debug'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _unlockAllLevels,
              child: const Text('Open all levels'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Coins amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _removeMoney,
                    child: const Text('-'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addMoney,
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
