import 'package:armar/armar.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/widgets.dart';

class ContinentTitleView extends ArGetLocatorWidget<ILevelsPickerPresenter> {
  const ContinentTitleView({super.key});

  @override
  Widget build(BuildContext context, ILevelsPickerPresenter presenter) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: FText(
          presenter.state.levels.name,
          textAlign: TextAlign.center,
          strokeWidth: 12,
          textStyle: const TextStyle(fontSize: 58),
        ),
      ),
    );
  }
}
