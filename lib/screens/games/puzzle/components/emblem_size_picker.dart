import 'package:collection/collection.dart';
import 'package:flags/uikit/components/buttons/button.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

class EmblemSizePicker extends StatefulWidget {
  const EmblemSizePicker({
    required this.initialValue,
    required this.scales,
    required this.onChanged,
    super.key,
  });

  final double initialValue;
  final List<double> scales;

  final void Function(double value) onChanged;

  @override
  State<EmblemSizePicker> createState() => _EmblemSizePickerState();
}

class _EmblemSizePickerState extends State<EmblemSizePicker> {
  late final ValueNotifier<int> currentActive = ValueNotifier(
    widget.scales.indexOf(widget.initialValue),
  );

  void onSelected(int index) {
    currentActive.value = index;
    widget.onChanged(widget.scales[index]);
  }

  @override
  void dispose() {
    currentActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxWidth),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            children: [
              ...widget.scales.mapIndexed(
                (i, e) => AspectRatio(
                  aspectRatio: 1,
                  child: ValueListenableBuilder(
                    valueListenable: currentActive,
                    builder: (
                      BuildContext context,
                      int value,
                      Widget? child,
                    ) {
                      final color =
                          value == i ? ThemePalette.green : ThemePalette.gray;

                      return FButton(
                        color: color,
                        onPressed: () => onSelected(i),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text("${i + 1}"),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
