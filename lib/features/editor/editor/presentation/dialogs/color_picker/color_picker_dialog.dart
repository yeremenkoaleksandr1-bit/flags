import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<Color?> showColorPickerDialog(
  BuildContext context,
  Color initialColor,
) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return _ColorPickerDialog(initialColor: initialColor);
  },
);

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initialColor});

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
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 420.w,
            maxHeight: mediaQuery.size.height * 0.82,
          ),
          child: FCard(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: onColorChange,
                    enableAlpha: false,
                  ),
                  Gap.v14,
                  FGreenButton(
                    onPressed: onConfirm,
                    child: Center(child: FText("Save")),
                  ),
                  Gap.v14,
                  FRedButton(
                    onPressed: onCancel,
                    child: Center(child: FText("Cancel")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
