import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color?> showColorPickerDialog(
  BuildContext context,
  Color initialColor,
) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ColorPickerDialog(
          initialColor: initialColor,
        );
      },
    );

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({
    super.key,
    required this.initialColor,
  });

  final Color initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color pickerColor = widget.initialColor;

  void onColorChange(Color value) {
    pickerColor = value;
  }

  void onConfirm() {
    Navigator.of(context).pop(pickerColor);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: onColorChange,
                  enableAlpha: false,
                ),
              ),
              FGreenButton(
                onPressed: onConfirm,
                child: Center(
                  child: FText("Save"),
                ),
              ),
              Gap.v14,
              FRedButton(
                onPressed: onCancel,
                child: Center(
                  child: FText("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
