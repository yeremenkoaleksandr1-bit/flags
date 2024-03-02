import 'package:armar/armar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'ar_dropdown.dart';
import 'item.dart';

class ArDropdownChangeableButton extends StatelessWidget {
  const ArDropdownChangeableButton({
    super.key,
    required this.items,
    required this.child,
    this.dropdownWidth = 240,
    this.onChanged,
    this.dropdownDirection = DropdownDirection.right,
    this.offset = Offset.zero,
    this.style,
    this.menuItemStyleData = const MenuItemStyleData(
      padding: EdgeInsets.zero,
    ),
    this.dropdownDecoration,
  });

  final Widget Function(bool active) child;

  final List<ArDropdownItem> items;
  final void Function(String? tag)? onChanged;

  final DropdownDirection dropdownDirection;
  final double dropdownWidth;

  final Offset offset;

  final TextStyle? style;
  final MenuItemStyleData menuItemStyleData;

  final BoxDecoration? dropdownDecoration;

  @override
  Widget build(BuildContext context) {
    return ArDropdownButton(
      items: items,
      onChanged: onChanged,
      dropdownWidth: dropdownWidth,
      dropdownDecoration: dropdownDecoration,
      menuItemStyleData: menuItemStyleData,
      style: style,
      offset: offset,
      builder: (active) => child(active),
    );
  }
}
