import 'package:armar/armar.dart';
import 'package:armar/state_management/get_utils/src/extensions/internacionalization.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../logger.dart';
import 'item.dart';

class ArDropdownButton<T> extends StatefulWidget {
  const ArDropdownButton({
    super.key,
    required this.items,
    required this.builder,
    this.dropdownWidth = 240,
    this.onChanged,
    this.dropdownDirection = DropdownDirection.right,
    this.offset = Offset.zero,
    this.style,
    this.menuItemStyleData = const MenuItemStyleData(
      padding: EdgeInsets.zero,
    ),
    this.dropdownDecoration,
    this.selectedItemBuilder,
    this.selectedWrapperBuilder,
    this.itemBuilder,
    this.value,
  });

  final Widget Function(bool active) builder;

  final List<ArDropdownItem> items;

  final void Function(T? value)? onChanged;

  final DropdownDirection dropdownDirection;
  final double? dropdownWidth;

  final Offset offset;

  final TextStyle? style;
  final MenuItemStyleData menuItemStyleData;
  final String? value;

  final BoxDecoration? dropdownDecoration;
  final Widget Function(Widget child, T value)? selectedItemBuilder;
  final Widget Function(Widget child, T value)? selectedWrapperBuilder;
  final Widget Function(Widget child, T value)? itemBuilder;

  @override
  State<ArDropdownButton<T>> createState() => _ArDropdownButtonState<T>();
}

class _ArDropdownButtonState<T> extends State<ArDropdownButton<T>> {
  final RxBool active = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: FastBuilder(
          () => widget.builder(active.value),
        ),
        enableFeedback: true,
        value: widget.value,
        onMenuStateChange: (v) => active.value = v,
        onChanged: (value) {
          widget.onChanged?.call(
              widget.items.firstWhereOrNull((e) => e.tag == value)?.value);
        },
        items: [
          ...widget.items.map(
            (e) {
              Widget child = e.child;

              if (widget.itemBuilder != null) {
                child = widget.itemBuilder!.call(child, e.value);
              }

              if (widget.selectedItemBuilder != null && widget.value == e.tag) {
                child = widget.selectedItemBuilder!.call(child, e.value);
              }

              if (widget.selectedWrapperBuilder != null &&
                  widget.value == e.tag) {
                child = widget.selectedWrapperBuilder!.call(
                  Padding(
                    padding: e.padding,
                    child: child,
                  ),
                  e.value,
                );
              } else {
                child = Padding(
                  padding: e.padding,
                  child: child,
                );
              }

              return DropdownItem<String>(
                value: e.tag,
                enabled: e.enabled,
                onTap: () => Future.microtask(() => e.onTap?.call()),
                child: child,
              );
            },
          )
        ],
        style: widget.style,
        menuItemStyleData: widget.menuItemStyleData,
        dropdownStyleData: DropdownStyleData(
          offset: widget.offset,
          direction: widget.dropdownDirection,
          elevation: 0,
          width: widget.dropdownWidth,
          padding: EdgeInsets.zero,
          decoration: widget.dropdownDecoration,
        ),
      ),
    );
  }
}
