import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flutter/cupertino.dart';

class FlagViewDialog extends DialogWidget {
  const FlagViewDialog({
    super.key,
    required this.flag,
  });

  final GameFlag flag;

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: SizedBox(
        width: double.infinity,
        child: FlagView(flag: flag),
      ),
    );
  }
}
